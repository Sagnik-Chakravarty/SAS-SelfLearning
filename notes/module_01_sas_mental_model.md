# Module 1 — SAS Mental Model for Survey Production

## Module Goal
By the end of this module, you should understand SAS as a production survey-data workflow system, not just a statistical language.

## 1. The Core SAS Mental Model

SAS works around this pattern

```
Raw data
  ↓
DATA step: create/clean/transform dataset
  ↓
PROC step: inspect/summarize/model/export/report
  ↓
Permanent dataset / table / public-use file / report
```

In r it can be thought of like this 

```{r}
df <- read_csv("sample.csv")
df_clean <- df %>% filter(eligible == 1)
```

In SAS, its usually like this:

```{sas}
data eligible_sample;
    set sample_file;
    if eligible == 1;
run;
```

That means:

```
Create a new SAS dataset called eligible_sample
from an existing SAS dataset called sample_file
keeping only eligible cases.
```
## 2. SAS Vocabulary

| SAS term    | R / Python / SQL equivalent                    |
| ----------- | ---------------------------------------------- |
| Dataset     | Data frame / table                             |
| Observation | Row                                            |
| Variable    | Column                                         |
| Library     | Folder / schema / data namespace               |
| DATA step   | Data transformation                            |
| PROC step   | Procedure: summary, model, export, SQL, report |
| WORK        | Temporary library                              |
| LIBNAME     | Permanent library assignment                   |

## 3. WORK Library vs Permanent Library

### WORK Library

If you create a dataset without specifying a library, SAS stores it in `WORK`.

```{sas}
data sample_clean;
    set sample_file;
run;
```

sas interprets this as

```{sas}
data work.sample_clean
    set work.sample_file
run;
```

`WORK` is fine for practice and intermediate files

### Permanenet Library

A permanent library ponts to a folder

```{sas}
libname myproj "/home/u123456/SAS-SelfLearning/data/processed";
```

Then you can save a permanent dataset

```{sas}
data myproj.clean_monthly_sample;
    set sample_clean;
run;
```

