{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      ocaml = {
        path = ./ocaml;
        description = "OCaml development flake";
      };
      
      node-typescript = {
        path = ./node-typescript-simple;
        description = "A NodeJS/TypeScript development flake";
      };

      deno = {
        path = ./deno;
        description = "Deno development flake";
      };
    };
  };
}
