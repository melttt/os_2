typedef unsigned int _off_t;
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

/*
 * need to implement these fuctions
extern node* malloc_node(node **a);
extern node* get_node_ptr(_off_t n);
extern void free_node(node *);
 *
 */



_off_t bpt_find(node *root, int key);
node* bpt_insert(node * root, int key, _off_t value);
node* bpt_delete(node * root, int key);


