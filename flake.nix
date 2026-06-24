{
  description = "My Emacs Flake";
  outputs = { self }: {
    packages.x86_64-linux.default = null;
  };
}
