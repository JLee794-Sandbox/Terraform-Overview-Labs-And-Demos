# Terraform Console Demo

## Prerequisites

### State Configuration

Terraform console will automatically leverage the backend configuration as specified in your provider(s).

#### Example Local State Configuration

```bash
terraform {
  backend "local" {
    # path = "relative/path/to/terraform.tfstate" 
  }
```

#### Example Remote State Configuration

```bash
terraform {
  ...
  backend "azurerm" {
    resource_group_name  = "<resource_group_name>"
    storage_account_name = "<storage_account_name>"
    container_name       = "<container_name>"
    key                  = "<path_to_state_file>"
  }
}
```

#### Sync Remote State Locally

Once you run init, you will have an empty state file. To update with existing remote state, run the following commands are available:

```bash
# Pulls the current state from the remote state
terraform state pull

# Dry run of your Terraform Plan to sync your current state with the remote state
terraform plan -refresh-only 

# Dry run of your Terraform Apply to sync your current state with the remote state
terraform apply -refresh-only
```

## Terraform Console Operations

### Initializing the Console

Start the console with the following command:

```bash
terraform console

# To reference a local state file (that isn't your default .terraform/terraform.tfstate), you can also run the following
# terraform console -state="relative/path/to/terraform.tfstate"
```

To provide an input variable value, use can do so with the following syntax:

```bash
terraform console -var="myvar=myvalue"
```

To provide a variable file:

```bash
terraform console -var-file="myvars.tfvars"
```


### Working with Variables

Within the Terraform console, you can leverage your variables in the same way you would in a terraform file.

```bash
> var.myvar
```



### Terraform Functions

Below is a table of available functions that can be used within the Terraform console.

> Note: This is not an exhaustive list(s)

#### String Functions

| Name | Description | Example |
| --- | --- | --- |
| `chomp()` | Removes trailing newline characters from a string | `chomp("hello\n")` |
| `format()` | Formats a string according to a format specifier | `format("Hello, %s!", "John")` |
| `formatlist()` | Formats a list of strings according to a format specifier | `formatlist("Hello, %s!", ["John", "Jane"])` |
| `indent()` | Indents each line of a string by a given number of spaces | `indent(2, "Hello\nWorld")` |
| `join()` | Joins a list into a string using a separator | `join(",", ["a", "b", "c"])` |
| `lower()` | Converts a string to lowercase | `lower("Hello")` |
| `regex()` | Returns the first substring matched by a regex | `regex("[a-z]+", "abc123def456")` |
| `regexall()` | Returns all substrings matched by a regex | `regexall("[a-z]+", "abc123def456")` |
| `replace()` | Replaces all occurrences of one substring with another | `replace("Hello World", "World", "Terraform")` |
| `split()` | Splits a string into a list of substrings | `split(",", "a,b,c")` |
| `substr()` | Returns a substring | `substr("Hello", 1, 3)` |
| `title()` | Converts a string to title case | `title("Hello world")` |
| `trim()` | Removes leading and trailing whitespace from a string | `trim(" Hello ")` |
| `trimprefix()` | Removes a prefix from a string | `trimprefix("Hello world", "Hello ")` |
| `trimspace()` | Removes leading and trailing whitespace from a string and reduces all other consecutive whitespace to a single space | `trimspace(" Hello world ")` |
| `trimsuffix()` | Removes a suffix from a string | `trimsuffix("Hello world", " world")` |
| `upper()` | Converts a string to uppercase | `upper("Hello")` |
| `uuid()` | Generates a Universally Unique Identifier (UUID) | `uuid()` |

#### Numeric Functions

| Name | Description | Example |
| --- | --- | --- |
| `abs()` | Returns the absolute value of a number | `abs(-1)` |
| `ceil()` | Returns the nearest integer that is greater than or equal to a number | `ceil(1.5)` |
| `floor()` | Returns the nearest integer that is less than or equal to a number | `floor(1.5)` |
| `max()` | Returns the maximum value of a list of numbers | `max([1, 2, 3])` |
| `min()` | Returns the minimum value of a list of numbers | `min([1, 2, 3])` |
| `signum()` | Returns the sign of a number (-1, 0, or 1) | `signum(-1)` |
| `signum()` | Returns the sign of a number (-1, 0, or 1) | `signum(-1)` |

#### Collection Functions

| Name | Description | Example |
| --- | --- | --- |
| `chunklist()` | Splits a list into a list of lists of a given size | `chunklist(["a", "b", "c", "d", "e"], 2)` |
| `coalesce()` | Returns the first non-null value in a list | `coalesce([null, null, "Hello"])` |
| `compact()` | Returns a list with all null values removed | `compact([null, null, "Hello"])` |
| `concat()` | Concatenates one or more lists into a single list | `concat(["a", "b"], ["c"], ["d"])` |
| `contains()` | Returns true if a list contains a given value | `contains(["a", "b", "c"], "b")` |
| `distinct()` | Returns a list with all duplicate elements removed | `distinct(["a", "b", "b", "c"])` |
| `flatten()` | Returns a list with all nested elements removed | `flatten([["a"], ["b"]])` |
| `index()` | Returns the index of a given value in a list | `index(["a", "b", "c"], "b")` |
| `keys()` | Returns the keys of a map as a list | `keys({a = 1, b = 2})` |
| `length()` | Returns the length of a list or string | `length("Hello")` |
| `list()` | Creates a list from a set of values | `list("a", "b", "c")` |
| `lookup()` | Looks up a value in a map or list of maps | `lookup({a = 1, b = 2}, "a")` |
| `map()` | Applies a function to each element of a list and returns a new list | `map({a = 1, b = 2}, "a")` |
| `matchkeys()` | Returns the keys of a map that match a given pattern | `matchkeys({a = 1, b = 2, c = 3}, "a*")` |
| `merge()` | Merges one or more maps into a single map | `merge({a = 1, b = 2}, {c = 3})` |
| `range()` | Returns a list of numbers in a given range | `range(1, 3)` |
| `reverse()` | Reverses a list | `reverse([1, 2, 3])` |
| `setproduct()` | Returns the Cartesian product of one or more lists | `setproduct(["a", "b"], ["c", "d"])` |
| `slice()` | Returns a subset of a list | `slice(["a", "b", "c"], 1, 2)` |
| `sort()` | Returns a list with all elements sorted | `sort(["b", "a", "c"])` |
| `transpose()` | Transposes a list of lists | `transpose([["a", "b"], ["c", "d"]])` |
| `values()` | Returns the values of a map as a list | `values({a = 1, b = 2})` |
| `zipmap()` | Creates a map from a list of keys and a list of values | `zipmap(["a", "b"], [1, 2])` |



You can also access workspaces via the console.

```bash
> terraform.workspace
```

### Modules

Similarly, you can access your modules the same way you would in a terraform file.
```bash
> module.app_service

```

### Access Data Objects Output

### Access Resource State Output

### Output Permutations

Structured Output
```
jsonencode({ arn = aws_s3_bucket.data.arn, id = aws_s3_bucket.data.id, region = aws_s3_bucket.data.region })
```
