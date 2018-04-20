#ifndef NULL
#define NULL ((void *)0)
#endif

#define TEST2 0

#define INF (0xff)
#define INFS (0xffffffff)

#define GENERAL_NODE 0
#define LEAF_NODE 1

typedef unsigned int _off_t;
#ifndef _BPT_NODE_
#define _BPT_NODE_
#define ORDER 5
#define KEYLEN ORDER
#define VALLEN (KEYLEN+1)

typedef struct node{
    char type;    //type: 0(general) 1(leaf)
    char num_keys;
    short empty1;
    _off_t parent;
    _off_t keys[KEYLEN];
    _off_t vals[VALLEN];
    _off_t where;
    _off_t next;
    int empty2;
}node ;
#endif

#define IS_GENERAL_NODE(c) (c->type == GENERAL_NODE)
#define IS_LEAF_NODE(c) (c->type == LEAF_NODE)

#define F_VALUE(c) (c)

/*
 * need to implement these fuctions
static node* malloc_node(node **a);
static node* get_node_ptr(_off_t n);
static void free_node(node *);
 */
static node* malloc_node(node **a);
static node* get_node_ptr(_off_t n);
static void free_node(node *);

//interface
_off_t bpt_find(node *root, int key);
node* bpt_insert(node * root, int key, _off_t value);
node* bpt_delete(node * root, int key);

#define MALLOC_NODE(a) malloc_node(a) 
#define GET_NODE_PTR(a) get_node_ptr(a)
#define FREE_NODE(a) free_node(a)
/* Creates a new general node, which can be adapted
 * to serve as either a leaf or an internal node.
 */



static node* make_node(void)
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
    new_node->next = INFS;
    
    return new_node;
}



/* Helper function used in insert_into_parent
 * to find the index of the parent's pointer to 
 * the node to the left of the key to be inserted.
 */
static node* make_leaf(void)
{
    node *leaf = make_node();
    leaf->type = LEAF_NODE;

    return leaf; 
}


/* Finds the appropriate place to
 * split a node that is too big into two.
 */
static int cut( int length ) {
	if (length % 2 == 0)
    {
		return length/2;
    }
	else
    {
		return length/2 + 1;
    }
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

    /*if(key == 130918)
    {
        extern void print_tree(node *a);
        print_tree(root);
    }
    */
	while (IS_GENERAL_NODE(c)) {
#if TEST2
        printf("num_keys : %d type : %d", c->num_keys, c->type);
        printf("[");
        for (i = 0; i < c->num_keys - 1; i++)
            printf("%d ", c->keys[i]);
        printf("%d] ", c->keys[i]);
        printf("\nvals:");
        for(i = 0 ; i < c->num_keys ; i ++)
            printf(" %d ", c->vals[i]);
        if(c->num_keys)
            printf(" %d ", c->vals[c->num_keys]);

#endif

		i = 0;
		while (i < c->num_keys) {
			if (key >= c->keys[i]) i++;
			else break;
		}

#if TEST2
		printf("%d ->\n", i);
#endif
		c = (node *)GET_NODE_PTR(c->vals[i]);
#if TEST2
#endif
	}

#if TEST2
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
_off_t bpt_find(node *root, int key) {
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
_off_t bpt_find_near(node *root, _off_t near){
	node *c = find_leaf(root, near);
    int i;
    int ret;
	if (c == NULL) return INFS;
    ret = c->keys[0];
    for(i = 0 ; i < c->num_keys ; i ++)
        if(c->keys[i] >= near)
        {
            ret = c->keys[i];
            break;
        }

    return ret;
}


/********************************************INSERT*****************************************/
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

	for(i = leaf->num_keys; i > insertion_point; i--) {
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
		n->keys[i] = n->keys[i - 1];
		n->vals[i + 1] = n->vals[i];
	}

	n->keys[left_index] = key;
	n->vals[left_index + 1] = right->where;
	n->num_keys++;
    
	return root;
}



static node * insert_into_parent(node * root, node * left, int key, node * right);

/* Inserts a new key and pointer to a node
 * into a node, causing the node's size to exceed
 * the order, and causing the node to split into two.
 */

static node * insert_into_node_after_splitting(node * root, node * old_node, int left_index, int key, node * right) {
    //printf("insert into node splitting\n");

	int i, j, split, k_prime;
	node *new_node, *child;
    int temp_vals[ORDER + 2];
    int temp_keys[ORDER + 1];

	/* First create a temporary set of keys and pointers
	 * to hold everything in order, including
	 * the new key and pointer, inserted in their
	 * correct places. 
	 * Then create a new node and copy half of the 
	 * keys and pointers to the old node and
	 * the other half to the new.
	 */


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
    //printf("insert into parent\n");

	int left_index;
	node * parent;

	parent = GET_NODE_PTR(left->parent);

	/* Case: new root. */

	if (parent == NULL)
    {
		return insert_into_new_root(left, key, right);
    }

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
    {
		return insert_into_node(root, parent, left_index, key, right);
    }

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

    //printf("insert_into_leaf_after_splitting\n");
	node *new_leaf;
	int insertion_index, split, new_key, i, j;
    int temp_keys[ORDER + 1];
    int temp_vals[ORDER + 1];

    if(leaf->num_keys != ORDER)
    {
#if TEST2
        printf("insert split in case : leaf->num_keys != ORDER");
#endif
        return NULL;
    }
	new_leaf = make_leaf();



	insertion_index = 0;
	while (insertion_index < leaf->num_keys && leaf->keys[insertion_index] < key)
		insertion_index++;

	for (i = 0, j = 0; i < leaf->num_keys; i++, j++) {
		if (j == insertion_index) j++;
		temp_keys[j] = leaf->keys[i];
		temp_vals[j] = leaf->vals[i];
	}

	temp_keys[insertion_index] = key;
	temp_vals[insertion_index] = value;

	leaf->num_keys = 0;
	split = cut(ORDER + 1);


	for(i = 0; i < split; i++) {
		leaf->vals[i] = temp_vals[i];
		leaf->keys[i] = temp_keys[i];
		leaf->num_keys++;
	}

	for(i = split, j = 0; i < ORDER + 1; i++, j++) {
		new_leaf->vals[j] = temp_vals[i];
		new_leaf->keys[j] = temp_keys[i];
		new_leaf->num_keys++;
	}




/*    
	new_leaf->vals[ORDER - 1] = leaf->vals[ORDER - 1];
	leaf->vals[ORDER - 1] = new_leaf->where;
*/


	for (i = leaf->num_keys; i < ORDER ; i++)
    {
		leaf->vals[i] = INFS;

    }
	for (i = new_leaf->num_keys; i < ORDER; i++)
    {
		new_leaf->vals[i] = INFS;
    }

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
node * bpt_insert(node * root, int key, _off_t value) {

	node *leaf;

	/* The current implementation ignores
	 * duplicates.
	 */
	if (bpt_find(root, key) != INFS)
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

/*****************************************delete***********************************/




static node * remove_entry_from_node(node * n, int key, _off_t value) {

	int i, num_pointers;

	// Remove the key and shift other keys accordingly.
	i = 0;
	while (n->keys[i] != key)
		i++;

	for (++i; i < n->num_keys; i++)
		n->keys[i - 1] = n->keys[i];

	// Remove the pointer and shift other pointers accordingly.
	// First determine number of pointers.
    //
	num_pointers = IS_LEAF_NODE(n) ? n->num_keys : n->num_keys + 1;
	i = 0;

	while (n->vals[i] != value)
		i++;
	for (++i; i < num_pointers; i++)
		n->vals[i - 1] = n->vals[i];

	// One key fewer.
	n->num_keys--;

	// Set the other pointers to NULL for tidiness.
	// A leaf uses the last pointer to point to the next leaf.
	if (IS_LEAF_NODE(n))
    {
		for (i = n->num_keys; i < ORDER; i++)
			n->vals[i] = INFS;
    }
	else
    {
		for (i = n->num_keys + 1; i < ORDER + 1; i++)
			n->vals[i] = INFS;
    }

	return n;
}



static node * adjust_root(node * root) {

	node * new_root;

	/* Case: nonempty root.
	 * Key and pointer have already been deleted,
	 * so nothing to be done.
	 */

	if (root->num_keys > 0)
		return root;

	/* Case: empty root. 
	 */

	// If it has a child, promote 
	// the first (only) child
	// as the new root.

	if (IS_GENERAL_NODE(root)) {
		new_root = GET_NODE_PTR(root->vals[0]);
		new_root->parent = INFS;
	}

	// If it is a leaf (has no children),
	// then the whole tree is empty.

	else
		new_root = NULL;

    FREE_NODE(root);
//	kfree(root);

	return new_root;
}

/* Utility function for deletion.  Retrieves
 * the index of a node's nearest neighbor (sibling)
 * to the left if one exists.  If not (the node
 * is the leftmost child), returns -1 to signify
 * this special case.
 */
static int get_neighbor_index( node * n ) {

	int i;
	/* Return the index of the key to the left
	 * of the pointer in the parent pointing
	 * to n.  
	 * If n is the leftmost child, this means
	 * return -1.
	 */
	for (i = 0; i <= GET_NODE_PTR(n->parent)->num_keys; i++)
		if (GET_NODE_PTR(n->parent)->vals[i] == n->where)
			return i - 1;

	// Error state.
#if TEST2
	printf("Search for nonexistent pointer to node in parent.\n");
	printf("Node:  %#lx\n", (unsigned long)n);
#endif
    //magic num =_+!
    return -3;
}



static node * delete_entry( node * root, node * n, int key, _off_t value );

/* Coalesces a node that has become
 * too small after deletion
 * with a neighboring node that
 * can accept the additional entries
 * without exceeding the maximum.
 */
static node * coalesce_nodes(node * root, node * n, node * neighbor, int neighbor_index, int k_prime) {

	int i, j, neighbor_insertion_index, n_end;
	node * tmp;

	/* Swap neighbor with node if node is on the
	 * extreme left and neighbor is to its right.
	 */
	if (neighbor_index == -1) {
		tmp = n;
		n = neighbor;
		neighbor = tmp;
	}

	/* Starting point in the neighbor for copying
	 * keys and pointers from n.
	 * Recall that n and neighbor have swapped places
	 * in the special case of n being a leftmost child.
	 */

	neighbor_insertion_index = neighbor->num_keys;

	/* Case:  nonleaf node.
	 * Append k_prime and the following pointer.
	 * Append all pointers and keys from the neighbor.
	 */

	if (IS_GENERAL_NODE(n)) {

		/* Append k_prime.
		 */
		neighbor->keys[neighbor_insertion_index] = k_prime;
		neighbor->num_keys ++;

		n_end = n->num_keys;

		for (i = neighbor_insertion_index + 1, j = 0; j < n_end; i++, j++) {
			neighbor->keys[i] = n->keys[j];
			neighbor->vals[i] = n->vals[j];
			neighbor->num_keys ++;
			n->num_keys --;
		}

		/* The number of pointers is always
		 * one more than the number of keys.
		 */

		neighbor->vals[i] = n->vals[j];
		/* All children must now point up to the same parent.
		 */

		for (i = 0; i < neighbor->num_keys + 1; i++) {
			tmp = GET_NODE_PTR(neighbor->vals[i]);
			tmp->parent = neighbor->where;
		}
	}

	/* In a leaf, append the keys and pointers of
	 * n to the neighbor.
	 * Set the neighbor's last pointer to point to
	 * what had been n's right neighbor.
	 */

	else {
		for (i = neighbor_insertion_index, j = 0; j < n->num_keys; i++, j++) {
			neighbor->keys[i] = n->keys[j];
			neighbor->vals[i] = n->vals[j];
			neighbor->num_keys ++;
		}
		//neighbor->vals[order - 1] = n->vals[order - 1];
	}

	root = delete_entry(root, GET_NODE_PTR(n->parent), k_prime, n->where);

    FREE_NODE(n);
//	kfree(n); 
	return root;
}

/* Redistributes entries between two nodes when
 * one has become too small after deletion
 * but its neighbor is too big to append the
 * small node's entries without exceeding the
 * maximum
 */
static node * redistribute_nodes(node * root, node * n, node * neighbor, int neighbor_index, 
		int k_prime_index, int k_prime) {  

	int i;
	node * tmp;

	/* Case: n has a neighbor to the left. 
	 * Pull the neighbor's last key-pointer pair over
	 * from the neighbor's right end to n's left end.
	 */
	if (neighbor_index != -1) {
		if (IS_GENERAL_NODE(n))
			n->vals[n->num_keys + 1] = n->vals[n->num_keys];

		for (i = n->num_keys; i > 0; i--) {
			n->keys[i] = n->keys[i - 1];
			n->vals[i] = n->vals[i - 1];
		}

		if (IS_GENERAL_NODE(n)) {
			n->vals[0] = neighbor->vals[neighbor->num_keys];
			tmp = GET_NODE_PTR(n->vals[0]);
			tmp->parent = n->where;
			neighbor->vals[neighbor->num_keys] = INFS;
			n->keys[0] = k_prime;
			GET_NODE_PTR(n->parent)->keys[k_prime_index] = neighbor->keys[neighbor->num_keys - 1];

		}
		else {
			n->vals[0] = neighbor->vals[neighbor->num_keys - 1];
			neighbor->vals[neighbor->num_keys - 1] = INF;
			n->keys[0] = neighbor->keys[neighbor->num_keys - 1];
			GET_NODE_PTR(n->parent)->keys[k_prime_index] = n->keys[0];
		}
	}

	/* Case: n is the leftmost child.
	 * Take a key-pointer pair from the neighbor to the right.
	 * Move the neighbor's leftmost key-pointer pair
	 * to n's rightmost position.
	 */

	else {  
		if (IS_LEAF_NODE(n)) {
			n->keys[n->num_keys] = neighbor->keys[0];
			n->vals[n->num_keys] = neighbor->vals[0];
			GET_NODE_PTR(n->parent)->keys[k_prime_index] = neighbor->keys[1];
		}
		else {
			n->keys[n->num_keys] = k_prime;
			n->vals[n->num_keys + 1] = neighbor->vals[0];
			tmp = GET_NODE_PTR(n->vals[n->num_keys + 1]);
			tmp->parent = n->where;
			GET_NODE_PTR(n->parent)->keys[k_prime_index] = neighbor->keys[0];
		}
		for (i = 0; i < neighbor->num_keys - 1; i++) {
			neighbor->keys[i] = neighbor->keys[i + 1];
			neighbor->vals[i] = neighbor->vals[i + 1];
		}
		if (IS_GENERAL_NODE(n))
			neighbor->vals[i] = neighbor->vals[i + 1];
	}

	/* n now has one more key and one more pointer;
	 * the neighbor has one fewer of each.
	 */

	n->num_keys++;
	neighbor->num_keys--;

	return root;
}


/* Deletes an entry from the B+ tree.
 * Removes the record and its key and pointer
 * from the leaf, and then makes all appropriate
 * changes to preserve the B+ tree properties.
 */
static node* delete_entry( node * root, node * n, int key, _off_t value ) {

	int min_keys;
	node * neighbor;
    _off_t neighbor_off_t;
	int neighbor_index;
	int k_prime_index, k_prime;
	int capacity;

	// Remove key and pointer from node.

	n = remove_entry_from_node(n, key, value);

	/* Case:  deletion from the root. 
	 */

	if (n == root) 
		return adjust_root(root);


	/* Case:  deletion from a node below the root.
	 * (Rest of function body.)
	 */

	/* Determine minimum allowable size of node,
	 * to be preserved after deletion.
	 */

	min_keys = IS_LEAF_NODE(n) ? cut(ORDER) : cut(ORDER + 1) - 1;

	/* Case:  node stays at or above minimum.
	 * (The simple case.)
	 */

	if (n->num_keys >= min_keys)
		return root;

	/* Case:  node falls below minimum.
	 * Either coalescence or redistribution
	 * is needed.
	 */

	/* Find the appropriate neighbor node with which
	 * to coalesce.
	 * Also find the key (k_prime) in the parent
	 * between the pointer to node n and the pointer
	 * to the neighbor.
	 */

	neighbor_index = get_neighbor_index(n);

	k_prime_index = neighbor_index == -1 ? 0 : neighbor_index;

	k_prime = GET_NODE_PTR(n->parent)->keys[k_prime_index];

	neighbor_off_t = neighbor_index == -1 ? GET_NODE_PTR(n->parent)->vals[1] : 
		GET_NODE_PTR(n->parent)->vals[neighbor_index];

    neighbor = GET_NODE_PTR(neighbor_off_t);

	capacity = IS_LEAF_NODE(n) ? ORDER : ORDER - 1;

	/* Coalescence. */

	if (neighbor->num_keys + n->num_keys <= capacity)
		return coalesce_nodes(root, n, neighbor, neighbor_index, k_prime);

	/* Redistribution. */
	else
		return redistribute_nodes(root, n, neighbor, neighbor_index, k_prime_index, k_prime);
}






/* Master deletion function.
 */
node * bpt_delete(node * root, int key) {

	node * key_leaf;
	_off_t  value_off_t;

	value_off_t = bpt_find(root, key);

	key_leaf = find_leaf(root, key);

	if (value_off_t != INFS && key_leaf != NULL) {

		root = delete_entry(root, key_leaf, key, value_off_t);
	}
	return root;
}

