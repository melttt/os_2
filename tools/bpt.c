#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#define TEST 1

#if TEST
#include <stdlib.h>
#define MALLOC_NODE(a) malloc_node(a) 
#define GET_NODE_PTR(a) get_node_ptr(a)
#endif 

typedef int _off_t;
#define ORDER 6
#define KEYLEN ORDER
#define VALLEN (KEYLEN+1)

#define INF (0xff)
#define INFS (0xffffffff)

#define GENERAL_NODE 0
#define LEAF_NODE 1

#define IS_GENERAL_NODE(c) (c->type == GENERAL_NODE)
#define IS_LEAF_NODE(c) (c->type == LEAF_NODE)

#define F_VALUE(c) (c)
typedef struct node{
    char type;    //type: 0(general) 1(leaf)
    char empty1;
    short num_keys;
    _off_t parent;
    _off_t keys[KEYLEN];
    _off_t vals[VALLEN];
    _off_t where;
}node ;


static node* node22222[1000];
#if TEST
node* malloc_node(node **a)
{
    static int cc = 0;
    *a = (node*)malloc(sizeof(node));
    (*a)->where = cc ++;
    node22222[(*a)->where] = *a;
    return *a;
}

node* get_node_ptr(_off_t n)
{
    return node22222[n];
}
#endif
    
/* Creates a new general node, which can be adapted
 * to serve as either a leaf or an internal node.
 */
node* make_node(void)
{
    node *new_node;
    //new_node = MALLOC_NODE();
    MALLOC_NODE(&new_node);
    if(new_node == NULL) 
    {
        return NULL;
    }
    
    new_node->type = GENERAL_NODE;
    new_node->parent = INFS;
    new_node->num_keys = 0;
    memset(new_node->keys, INF, sizeof(new_node->keys));
    memset(new_node->vals, INF, sizeof(new_node->vals));
    
    return new_node;
}

/* Helper function used in insert_into_parent
 * to find the index of the parent's pointer to 
 * the node to the left of the key to be inserted.
 */
node* make_leaf(void)
{
    node *leaf = make_node();
    leaf->type = LEAF_NODE;

    return leaf; 
}
   


/* Finds the appropriate place to
 * split a node that is too big into two.
 */
int cut( int length ) {
	if (length % 2 == 0)
		return length/2;
	else
		return length/2 + 1;
}

/*-----------------------------------FIND----------------------------------------*/



/* Traces the path from the root to a leaf, searching
 * by key.  Displays information about the path
 * if the verbose flag is set.
 * Returns the leaf containing the given key.
 */
static node* find_leaf(node *root, int key) {
	int i = 0;
	node *c = root;
	if (c == NULL) {
		return c;
	}

	while (IS_GENERAL_NODE(c)) {
#if TEST
        printf("[");
        for (i = 0; i < c->num_keys - 1; i++)
            printf("%d ", c->keys[i]);
        printf("%d] ", c->keys[i]);
#endif

		i = 0;
		while (i < c->num_keys) {
			if (key >= c->keys[i]) i++;
			else break;
		}

#if TEST
		printf("%d ->\n", i);
#endif
		c = (node *)GET_NODE_PTR(c->vals[i]);
	}

#if TEST
    printf("Leaf [");
    for (i = 0; i < c->num_keys - 1; i++)
        printf("%d ", c->keys[i]);
    printf("%d] ->\n", c->keys[i]);
#endif

	return c;
}


/* Finds and returns the record to which
 * a key refers.
 */
_off_t find(node *root, int key) {
	int i = 0;
	node *c = find_leaf(root, key);

	if (c == NULL) return INFS;
	for (i = 0; i < c->num_keys; i++)
		if (c->keys[i] == key) break;

	if (i == c->num_keys) 
		return INFS;
	else
		return c->vals[i];
}



/********************************************INSERT****************/
/* Helper function used in insert_into_parent
 * to find the index of the parent's pointer to 
 * the node to the left of the key to be inserted.
 */
static int get_left_index(node *parent, node* left)
{
    int left_index = 0;
    while(left_index <= parent->num_keys && 
            parent->vals[left_index] != left->where)
        left_index ++;
    return left_index;
}

 
/* First insertion:
 * start a new tree.
 */
static node * start_new_tree(int key, _off_t value)
{
	node * root = make_leaf();
	root->keys[0] = key;
    root->vals[0] = value;
	root->parent = INFS;
	root->num_keys ++;
	return root;
}

/* Creates a new root for two subtrees
 * and inserts the appropriate key into
 * the new root.
 */
static node * insert_into_new_root(node * left, int key, node * right) {

	node * root = make_node();
	root->keys[0] = key;
	root->vals[0] = left->where;
	root->vals[1] = right->where;
	root->num_keys++;
	root->parent = INFS;
	left->parent = root->where;
	right->parent = root->where;
	return root;
}

/* Inserts a new pointer to a record and its corresponding
 * key into a leaf.
 * Returns the altered leaf.
 */
static node* insert_into_leaf(node * leaf, int key, _off_t value) 
{
	int i, insertion_point;

	insertion_point = 0;
	while (insertion_point < leaf->num_keys && leaf->keys[insertion_point] < key)
		insertion_point++;

	for (i = leaf->num_keys; i > insertion_point; i--) {
		leaf->keys[i] = leaf->keys[i - 1];
		leaf->vals[i] = leaf->vals[i - 1];
	}

	leaf->keys[insertion_point] = key;
	leaf->vals[insertion_point] = value;
	leaf->num_keys++;
	return leaf;
}


/* Inserts a new key and pointer to a node
 * into a node into which these can fit
 * without violating the B+ tree properties.
 */
static node * insert_into_node(node * root, node * n, 
		int left_index, int key, node * right) {
	int i;

	for (i = n->num_keys; i > left_index; i--) {
		n->vals[i + 1] = n->vals[i];
		n->keys[i] = n->keys[i - 1];
	}

	n->vals[left_index + 1] = right->where;
	n->keys[left_index] = key;
	n->num_keys++;
	return root;
}



static node * insert_into_parent(node * root, node * left, int key, node * right);
/* Inserts a new key and pointer to a node
 * into a node, causing the node's size to exceed
 * the order, and causing the node to split into two.
 */
static node * insert_into_node_after_splitting(node * root, node * old_node, int left_index, 
		int key, node * right) {

	int i, j, split, k_prime;
	node *new_node, *child;
	int * temp_keys;
	_off_t *temp_vals;

	/* First create a temporary set of keys and pointers
	 * to hold everything in order, including
	 * the new key and pointer, inserted in their
	 * correct places. 
	 * Then create a new node and copy half of the 
	 * keys and pointers to the old node and
	 * the other half to the new.
	 */

	temp_vals = malloc( (ORDER + 2) * sizeof(_off_t) );
	if (temp_vals == NULL) {

#if TEST
    printf("temp_vals node\n");
#endif

	}

	temp_keys = malloc( (ORDER + 1) * sizeof(int) );
	if (temp_keys == NULL) {

#if TEST
    printf("temp_keys node\n");
#endif

	}

	for (i = 0, j = 0; i < old_node->num_keys + 1; i++, j++) {
		if (j == left_index + 1) j++;
		temp_vals[j] = old_node->vals[i];
	}

	for (i = 0, j = 0; i < old_node->num_keys; i++, j++) {
		if (j == left_index) j++;
		temp_keys[j] = old_node->keys[i];
	}

	temp_vals[left_index + 1] = right->where;
	temp_keys[left_index] = key;

	/* Create the new node and copy
	 * half the keys and pointers to the
	 * old and half to the new.
	 */  
	split = cut(ORDER + 1);
	new_node = make_node();
	old_node->num_keys = 0;

	for (i = 0; i < split - 1; i++) {
		old_node->vals[i] = temp_vals[i];
		old_node->keys[i] = temp_keys[i];
		old_node->num_keys++;
	}
	old_node->vals[i] = temp_vals[i];
	k_prime = temp_keys[split - 1];

	for (++i, j = 0; i < ORDER + 1; i++, j++) {
		new_node->vals[j] = temp_vals[i];
		new_node->keys[j] = temp_keys[i];
		new_node->num_keys++;
	}

	new_node->vals[j] = temp_vals[i];

	free(temp_vals);
	free(temp_keys);


	new_node->parent = old_node->parent;
	for (i = 0; i <= new_node->num_keys; i++) {
		child = GET_NODE_PTR(new_node->vals[i]);
		child->parent = new_node->where;
	}

	/* Insert a new key into the parent of the two
	 * nodes resulting from the split, with
	 * the old node to the left and the new to the right.
	 */

	return insert_into_parent(root, old_node, k_prime, new_node);
}

/* Inserts a new node (leaf or internal node) into the B+ tree.
 * Returns the root of the tree after insertion.
 */
static node * insert_into_parent(node * root, node * left, int key, node * right) {

	int left_index;
	node * parent;

	parent = GET_NODE_PTR(left->parent);

	/* Case: new root. */

	if (parent == NULL)
		return insert_into_new_root(left, key, right);

	/* Case: leaf or node. (Remainder of
	 * function body.)
	 */

	/* Find the parent's pointer to the left
	 * node.
	 */
	left_index = get_left_index(parent, left);

	/* Simple case: the new key fits into the node.
	 */
	if (parent->num_keys + 1 <= ORDER)
		return insert_into_node(root, parent, left_index, key, right);

	/* Harder case:  split a node in order
	 * to preserve the B+ tree properties.
	 */
	return insert_into_node_after_splitting(root, parent, left_index, key, right);
}


/* Inserts a new key and pointer
 * to a new record into a leaf so as to exceed
 * the tree's order, causing the leaf to be split
 * in half.
 */
static node* insert_into_leaf_after_splitting(node *root, node *leaf,int key,_off_t value) {

	node *new_leaf;
	int *temp_keys;
	int *temp_vals;
	int insertion_index, split, new_key, i, j;

	new_leaf = make_leaf();

	temp_keys = malloc((ORDER+1) * sizeof(int));
	if (temp_keys == NULL) {
#if TEST
        printf("temp_keys == NULL\n");
#endif
        return NULL;
	}

	temp_vals = malloc((ORDER+1) * sizeof(_off_t) );
	if (temp_vals == NULL) {
#if TEST
        printf("temp_vals == NULL\n");
#endif
        return NULL;
	}


	insertion_index = 0;
	while (insertion_index < ORDER && leaf->keys[insertion_index] < key)
		insertion_index++;

	for (i = 0, j = 0; i < leaf->num_keys; i++, j++) {
		if (j == insertion_index) j++;
		temp_keys[j] = leaf->keys[i];
		temp_vals[j] = leaf->vals[i];
	}

	temp_keys[insertion_index] = key;
	temp_vals[insertion_index] = value;

	leaf->num_keys = 0;
	split = cut(ORDER);


	for(i = 0; i < split; i++) {
		leaf->vals[i] = temp_vals[i];
		leaf->keys[i] = temp_keys[i];
		leaf->num_keys++;
	}

	for(i = split, j = 0; i < ORDER+1; i++, j++) {
		new_leaf->vals[j] = temp_vals[i];
		new_leaf->keys[j] = temp_keys[i];
		new_leaf->num_keys++;
	}

	free(temp_vals);
	free(temp_keys);

/*    
	new_leaf->vals[ORDER - 1] = leaf->vals[ORDER - 1];
	leaf->vals[ORDER - 1] = new_leaf->where;
*/


	for (i = leaf->num_keys; i < ORDER ; i++)
		leaf->vals[i] = INFS;
	for (i = new_leaf->num_keys; i < ORDER; i++)
		new_leaf->vals[i] = INFS;

	new_leaf->parent = leaf->parent;
	new_key = new_leaf->keys[0];

	return insert_into_parent(root, leaf, new_key, new_leaf);
}
/* Master insertion function.
 * Inserts a key and an associated value into
 * the B+ tree, causing the tree to be adjusted
 * however necessary to maintain the B+ tree
 * properties.
 */
node * insert(node * root, int key, _off_t value) {

	node *leaf;

	/* The current implementation ignores
	 * duplicates.
	 */
	if (find(root, key) != INFS)
		return root;

    
    value = F_VALUE(value);

	/* Case: the tree does not exist yet.
	 * Start a new tree.
	 */

	if (root == NULL) 
		return start_new_tree(key, value);


	/* Case: the tree already exists.
	 * (Rest of function body.)
	 */

	leaf = find_leaf(root, key);

	/* Case: leaf has room for key and pointer.
	 */

	if (leaf->num_keys + 1 <= ORDER) {
		leaf = insert_into_leaf(leaf, key, value);
		return root;
	}

	/* Case:  leaf must be split.
	 */

	return insert_into_leaf_after_splitting(root, leaf, key, value);
}






/***************************************TEST************************/
    
//get file size

size_t get_file_size(const char *path)
{
    size_t filesize = -1;
    struct stat statbuf;
    if(stat(path, &statbuf) < 0)
    {
        return filesize;
    }

    filesize = statbuf.st_size;
    return filesize;
}
   

/* Utility function to give the length in edges
 * of the path from any node to the root.
 */
int path_to_root( node * root, node * child ) {
	int length = 0;
	node * c = child;
	while (c != root) {
		c = get_node_ptr(c->parent);
		length++;
	}
	return length;
}

void print_tree(node *root)
{
    node *n = NULL;
    int i = 0;
    int rank = 0;
    int new_rank = 0;
    node* queue[100]; 
    int que_rear = 0;
    int que_front = 0;

    if(root == NULL)
    {
        printf("Empty tree.\n");
        return;
    }

    queue[que_rear ++] = root;
    while(que_rear != que_front)
    {
        n = queue[que_front ++];        
        if(n->parent != INFS && n == get_node_ptr(get_node_ptr(n->parent)->vals[0])) 
        {
           new_rank = path_to_root(root ,n); 
           if(new_rank != rank)
           {
               rank = new_rank;
               printf("\n");
           }
        }
        printf("addr:(%lx) ", n->where);
        for(i = 0 ; i < n->num_keys ; i ++)
        {
            printf("keys:%d ", n->keys[i]);
            printf("vals:%lx ", (unsigned long)n->vals[i]);
        }

        if(IS_GENERAL_NODE(n))
        {
            for(i = 0 ; i <= n->num_keys ; i ++)
                queue[que_rear ++] = get_node_ptr(n->vals[i]);
        }

        if(IS_LEAF_NODE(n))
        {
            //printf("lx ", (unsigned long)n->vals[ORDER - 1]);
        }else{
            printf("vals:%lx ", (unsigned long)n->vals[n->num_keys]);
        }
        printf("| ");

    }
    printf("\n");
}



void test()
{
    printf("start test\n");
    node *root = NULL;
    for(int i = 0 ; i < 22 ; i ++)
        root = insert(root, i, i);

    printf("TEST INSERT\n");
    print_tree(root);

}
int main()
{
    if(sizeof(node) > 64)
    {
        printf("error size of node\n exit ...");
        return 1;
    }


    printf("size of node :%d \n", sizeof(node));
//    printf("fs.img 's size = %d \n", get_file_size("fs.img")/1024/1024);


    test();



    return 0;
}







