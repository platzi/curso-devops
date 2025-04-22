# Material para la clase 16

Estas son las consultas que vas a utilizar:

```kql
requests
| where success == 'True'

requests
| summarize AverageDuration = avg(duration)

requests
| summarize OperationCount = count() by operation_Name
| sort by OperationCount desc
| top 1 by OperationCount
```
