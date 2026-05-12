# Module 1A — Absolute SAS Basics

## 1. What is a “dataframe” in SAA

In SAS the closest equivalent to dataframe is called a dataset

| R / Python              | SAS             |
|-------------------------|-----------------|
| dataframe               | dataset         |
| column                  | variable        |
| row                     | observation     |
| object name             | dataset name    |
| create dataframe        | `DATA` step     |
| read existing dataframe | `SET` statement |

So when we say

```{sas}
data sample_file;
```

We mean

> Create a SAS dataset called `sample_file`.

This is like:

```{r}
sample_file <- data.frame(...)
```

## How to create a small dataset manually in SAS

we wanna recreate this R data set in SAS:

```{sas}
sample_file <- data.frame(
  sample_id = c("S001", "S002", "S003"),
  region = c("Northeast", "Midwest", "South"),
  eligible = c(1, 1, 0)
)
```

In SAS:

```{sas}
data sample_file;
    input sample_id $ region $ eligible;
    datalines;
S001 Northeast 1
S002 Midwest 1
S003 South 0
;
run;
```

#### What each line means

```{sas}
data sample_file;
```

Create a dataset called `sample_file`.

```{sas}
input sample_id $ region $ eligible;
```

Tell SAS what variable to expect

The `$` means the variable is character/text.

So

```{sas}
sample_id $
region $
```

means `sample_id` and `region` are text variable

but `eligible` has no `$` meaning SAS must treat it as a numeric variable

```{sas}
datalines;
```

This tells SAS that the user will enter data after this line

```{sas}
S001 Northeast 1
S002 Midwest 1
S003 South 0
```

These are the rows

## 3. What is `SET`?

`SET` means: \> Read an existing SAS dataset row by row

Example:

```{sas}
data eligible_sample;
    set sample_file;
    if eligible = 1;
run;
```

This means

> Create a new dataset called eligible_sample by reading from the existing dataset `sample_file`, and keep only rows where `eligible = 1`.

R equivalent:

```{r}
eligible_sample <- sample_file %>%
  filter(eligible == 1)
```

So the key thing:

```{sas}
data new_dataset;
    set old_dataset;
run;
```

means:

> make a new dataset from old dataset

## 4.DATA step structure

Most simple SAS data creation follows this pattern:

```{sas}
data new_dataset_name;
    set old_dataset_name;
    /* transformations go here */
run;
```

Example:

```{sas}
data sample_with_response;
    set sample_file;
    responded = 0;
run;
```

This creates a new variable called responded

R equivalent:

```{r}
sample_with_response <- sample_file %>% 
    mutate(responded = 0)
```

## 5. Creating new Variables

In SAS:

```{sas}
data sample_clean;
    set sample_file;
    web_case = assigned_mode = "Web";
run;
```

This creates the `web_case` which is a boolean 

More readable version

```{sas}
data sample_clean;
    set sample_file;

    if assigned_mode = "Web" then web_case = 1;
    else web_case = 0;
run;
```

## 6. Character vs numeric variables

SAS has two basic variable types

| Type      | Meaning     | Example                                |
| --------- | ----------- | -------------------------------------- |
| Numeric   | numbers     | `age`, `weight`, `eligible`            |
| Character | text/string | `sample_id`, `region`, `assigned_mode` |


When creating data manually use `$` for character variables.

```{sas}
input sample_id $ region $ age weight;
```

This means

```
sample_id = character
region = character
age = numeric
weight = numeric
```

important ID should be character 


## 7. What is `LENGTH`?

`LENGTH` tells SAS how much space to reserve for character variables

Example:

```{sas}
data sample_file;
    length sample_id $8 region $12 assigned_mode $8;
    input sample_id $ region $ assigned_mode $ eligible;
    datalines;
S001 Northeast Web 1
S002 Midwest Mail 1
S003 South Phone 0
;
run;
```

Why use `LENGTH`?

Because SAS can otherwise guess short lengths and truncate text

For example, if SAS first sees `"Web"`, it may think the variable only needs 3 chracters. later `"Telephone"` can be truncated.

## 8. What is `PROC PRINT`?

`PROC PRINT` shows the data.

```{sas}
proc print data=sample_file;
run;
```

R equivalent

```{r}
print(sample_file)
```

To print only first 5 rows:

```{sas}
proc print data=sample_file(obs=5);
```

## 9. What is `PROC CONTENTS`?

`PROC CONTENTS` show the structure of the dataset.

```{sas}
proc contents data=sample_file;
run;
```

it tells you

```
variable names
variable types
variable lengths
number of rows
labels/formats if present
```

R equivalent

```{r}
str(sample_file)
```

## 10. What is `PROC FREQ`?

`PROC FREQ` giives the frequency for categorical variables.

```{sas}
proc freq data=sample_file;
    tables region assigned_mode / missing;
run;
```