# Terraform Console Demo

This document is intended to serve as an educational resource for Terraform Console. It is not intended to be a comprehensive guide to Terraform Console. For more information, please see the [Terraform Console Documentation](https://www.terraform.io/docs/commands/console.html).

## Getting Started

### State Configuration

Terraform console will automatically leverage the backend configuration as specified in your **current** Terraform directory files.

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

### Accessing Variables

Within the Terraform console, you can leverage your variables in the same way you would in a terraform file.

```bash
> var.myvar
"myvalue"
```

### Using Operators

You can use operators in the Terraform console to perform operations on variables.

```bash
> var.myvar + " is cool"
"myvalue is cool"
```

### Using Functions

You can use functions in the Terraform console to perform operations on variables.

```bash
> format("Hello, %s!", var.myvar)
"Hello, myvalue!"
```

### Using Loops

You can use loops in the Terraform console to perform operations on variables.

```bash
> [for i in range(1, 5) : i]
[
  1,
  2,
  3,
  4,
  5
]
```

### Some more 'complex' examples

#### Example 1: Using a for expression to create a list of objects

```bash
> [for i in range(1, 5) : { id = i }]
[
  {
    "id" = 1
  },
  {
    "id" = 2
  },
  {
    "id" = 3
  },
  {
    "id" = 4
  },
  {
    "id" = 5
  }
]
```

#### Example 2: Using a for expression to create a list of strings

```bash
> [for i in range(1, 5) : "id-${i}"]
[
  "id-1",
  "id-2",
  "id-3",
  "id-4",
  "id-5"
]
```

#### Example 3: Using a for expression to create a map of strings

```bash
> { for i in range(1, 5) : "id-${i}" => i }
{
  "id-1" = 1
  "id-2" = 2
  "id-3" = 3
  "id-4" = 4
  "id-5" = 5
}
```

#### Example 4: Using a for expression to create a list of objects with a nested for expression

```bash
> [for i in range(1, 5) : { id = i, nested = [for j in range(1, 3) : j] }]
[
  {
    "id" = 1
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 2
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 3
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 4
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 5
    "nested" = [
      1,
      2,
      3
    ]
  }
]
```

#### Example 5: Using a for expression to create a list of objects with a nested for expression, and a conditional

```bash
> [for i in range(1, 5) : { id = i, nested = [for j in range(1, 3) : j] if i % 2 == 0 }]
[
  {
    "id" = 2
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 4
    "nested" = [
      1,
      2,
      3
    ]
  }
]
```

#### Example 6: Using a for expression to create a list of objects with a nested for expression, and a conditional, and a filter

```bash
> [for i in range(1, 5) : { id = i, nested = [for j in range(1, 3) : j] if i % 2 == 0 } if i % 2 == 0]
[
  {
    "id" = 2
    "nested" = [
      1,
      2,
      3
    ]
  },
  {
    "id" = 4
    "nested" = [
      1,
      2,
      3
    ]
  }
]
```


### Accessing State Objects

You can access outputs of `resources`, `data` blocks, and `modules` in the same way you would in a terraform file.

For example, suppose we have an aks resource definition like below:

```bash
resource "azurerm_kubernetes_cluster" "k8s" {
  ...
}
```

After applying the configuration, you can access the attributes of the resource like so:

```bash
# Retrieve the name
> azurerm_kubernetes_cluster.k8s.name
"myCoolCluster"

# Retrieve the default node pool
> azurerm_kubernetes_cluster.k8s.default_node_pool
tolist([
  {
    "capacity_reservation_group_id" = ""
    "enable_auto_scaling" = true
    "enable_host_encryption" = false
    ...
  }
])

```

Now suppose we wanted to test out a function to:
  1. Loop through each of the default node pools.
  3. Return a list of maps with the `name` and `enable_auto_scaling` attributes extracted.

To do so, we can now use the Terraform console to iteratively test our logic as we piece them together.

1. Loop through each of the default node pools

    Since the `default_node_pool` attribute returns a list of objects, you can use the `for` expression to loop through the list, and then use the terraform syntax to access each of the objects attributes.

    ```bash
    > [for pool in azurerm_kubernetes_cluster.k8s.default_node_pool : pool]
    [
      {
        "capacity_reservation_group_id" = ""
        "enable_auto_scaling" = true
        "enable_host_encryption" = false
        ...
      }
    ]
    ```


2. Return a list of maps with the extracted attributes
    
     We are already returning a list of objects, so now within our `for` expression, we can return an object with the attributes we want.

    ```bash
    > [for pool in azurerm_kubernetes_cluster.k8s.default_node_pool : { pool.name, enable_auto_scaling}]
    [
      {
        "enable_auto_scaling" = true
        "name" = "myCoolCluster"
      }
    ]
    ```

## Terraform Functions

Below are some tables of available functions that can be used within the Terraform (and therefore in the console).

> Note: This is not an exhaustive list


<details>
<summary>String Functions</summary>
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
</details>

<details>
<summary>Numeric Functions</summary>
| Name | Description | Example |
| --- | --- | --- |
| `abs()` | Returns the absolute value of a number | `abs(-1)` |
| `ceil()` | Returns the nearest integer that is greater than or equal to a number | `ceil(1.5)` |
| `floor()` | Returns the nearest integer that is less than or equal to a number | `floor(1.5)` |
| `max()` | Returns the maximum value of a list of numbers | `max([1, 2, 3])` |
| `min()` | Returns the minimum value of a list of numbers | `min([1, 2, 3])` |
| `signum()` | Returns the sign of a number (-1, 0, or 1) | `signum(-1)` |
| `signum()` | Returns the sign of a number (-1, 0, or 1) | `signum(-1)` |
</details>

<details>
<summary>Collection Functions</summary>

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
</details>


You can also access workspaces via the console.

```bash
> terraform.workspace
```
