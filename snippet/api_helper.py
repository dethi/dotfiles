#!/usr/bin/env python

def info(obj, spacing=10, collapse=True):
    """Print methods and doc string.
    Takes any object."""
    methods = [method for method in dir(obj) if callable(getattr(obj, method))]
    process = collapse and (lambda s: " ".join(s.split())) or (lambda s: s)
    print("\n".join(["{} {}".format(method.ljust(spacing),
                                    process(str(getattr(obj, method).__doc__)))
                    for method in methods]))

if __name__ == "__main__":
    print(info.__doc__)
