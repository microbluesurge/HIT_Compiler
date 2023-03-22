#ifndef NODE_H
#define NODE_H

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "enum.h"

#define TRUE 1
#define FALSE 0

typedef struct node {
    int lineNo;  //  node in which line
    NodeType type;  // node type
    char* name;     //  node name
    char* val;      //  node value
    struct node* child;  //  non-terminals node first child node
    struct node* next;   //  non-terminals node next brother node
} Node;

typedef unsigned boolean;
typedef Node* pNode;

static inline char* newString(char* src) {
    if (src == NULL) return NULL;
    int length = strlen(src) + 1;
    char* p = (char*)malloc(sizeof(char) * length);
    assert(p != NULL);
    strncpy(p, src, length);
    return p;
}

static inline pNode newNode(int lineNo, NodeType type, char* name, char* tokenVal, int argc, ...) {
    pNode curNode = NULL;
    curNode = (pNode)malloc(sizeof(Node));
    curNode->name = newString(name);
    curNode->lineNo = lineNo;
    curNode->type = type;

    if(argc != 0){
        va_list vaList;
        va_start(vaList, argc);
        pNode tempNode = va_arg(vaList, pNode);
        curNode->child = tempNode;
        for (int i = 1; i < argc; i++) {
            tempNode->next = va_arg(vaList, pNode);
            if (tempNode->next != NULL) {
                tempNode = tempNode->next;
            }
        }
        va_end(vaList);
    }
    else{
        curNode->val = newString(tokenVal);
        curNode->child = NULL;
        curNode->next = NULL;
    }
    return curNode;
}

static inline void printTreeInfo(pNode curNode, int height) {
    if (curNode == NULL) {
        return;
    }

    for (int i = 0; i < height; i++) {
        printf("  ");
    }
    if(!strcmp(curNode->name, "OCT") || !strcmp(curNode->name, "HEX"))
        printf("INT");
    else
        printf("%s",curNode->name);
    
    if (curNode->type == NOT_A_TOKEN) {
        printf(" (%d)", curNode->lineNo);
    } 
    else if (curNode->type == TOKEN_TYPE || curNode->type == TOKEN_ID || curNode->type == TOKEN_INT) {
        if(!strcmp(curNode->name, "OCT")){
            int tempLen = strlen(curNode->val);
            int valTemp = 0;
            int weight_oct = 1;
            for(int i = tempLen - 1; i > 0; i--){
                valTemp += (curNode->val[i] - '0')*weight_oct;
                weight_oct *= 8;
            }
            printf(": %d", valTemp);
        }
        else if(!strcmp(curNode->name, "HEX")){
            int tempLen = strlen(curNode->val);
            int valTemp = 0;
            int weight_hex = 1;
            for(int i = tempLen - 1; i > 1; i--){
                if(curNode->val[i] >= '0' && curNode->val[i] <= '9')
                    valTemp += (curNode->val[i] - '0')*weight_hex;
                else
                    valTemp += (curNode->val[i] - 'A' + 10)*weight_hex;
                weight_hex *= 16;
            }
            printf(": %d", valTemp);
        }
        else 
            printf(": %s", curNode->val);
    } 
    else if (curNode->type == TOKEN_FLOAT) { 
        printf(": %lf", atof(curNode->val));
    }
    printf("\n");
    printTreeInfo(curNode->child, height + 1);
    printTreeInfo(curNode->next, height);
}
#endif