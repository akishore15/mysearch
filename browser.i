#include <stdio.h>
#include <stdlib.h>
#include "libwebsockets.h"
#include "duktape.h"

// Function to read a file into a string
char *read_file(const char *filename) {
    FILE *file = fopen(filename, "rb");
    if (!file) return NULL;

    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    fseek(file, 0, SEEK_SET);

    char *content = malloc(length + 1);
    if (content) {
        fread(content, 1, length, file);
        content[length] = '\0';
    }

    fclose(file);
    return content;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <search query>\n", argv[0]);
        return 1;
    }

    const char *query = argv[1];
    
    // Initialize Duktape context
    duk_context *ctx = duk_create_heap_default();
    if (!ctx) {
        fprintf(stderr, "Failed to create a Duktape heap.\n");
        return 1;
    }

    // Read and evaluate the compiled TypeScript file (search.ts)
    char *search_script = read_file("search.ts");
    if (!search_script) {
        fprintf(stderr, "Failed to read search.ts.\n");
        duk_destroy_heap(ctx);
        return 1;
    }

    if (duk_peval_string(ctx, search_script) != 0) {
        fprintf(stderr, "Error: %s\n", duk_safe_to_string(ctx, -1));
        free(search_script);
        duk_destroy_heap(ctx);
        return 1;
    }
    free(search_script);

    // Call the search function
    duk_push_global_object(ctx);
    duk_get_prop_string(ctx, -1, "search");
    duk_push_string(ctx, query);

    if (duk_pcall(ctx, 1) != 0) {
        fprintf(stderr, "Error: %s\n", duk_safe_to_string(ctx, -1));
    } else {
        printf("%s\n", duk_safe_to_string(ctx, -1));
    }

    duk_pop(ctx);
    duk_destroy_heap(ctx);

    return 0;
}
