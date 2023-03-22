#include "inter.h"
#include "syntax.tab.h"

extern pNode root;

extern int yylineno;
extern int yyparse();
extern void yyrestart(FILE*);

unsigned lexError = FALSE;
unsigned synError = FALSE;

int main(int argc, char** argv) {
    if (argc <= 1) {
        yyparse();
        return 1;
    }

    FILE* f = fopen(argv[1], "r");
    if (!f) {
        perror(argv[1]);
        return 1;
    }

    FILE* fw = fopen(argv[2], "wt+");
    if (!fw) {
        perror(argv[2]);
        return 1;
    }

    yyrestart(f);
    yyparse();
    if (!lexError && !synError) {
        table = initTable();
        traverseTree(root);
        interCodeList = newInterCodeList();
        genInterCodes(root);
        if (!interError)
            printInterCode(fw, interCodeList);
        deleteTable(table);
    }
    return 0;
}
