# Exercise PowerShell Variables and Arrays
## Prerequisites and Guidelines
- Cmdlets must run on VM Windows Server (preferably with Remoting Session)
- Run the commandlets, analyze the output and write briefly your observation.
- Use PowerShell 7.6 Core otherwise mentioned explicitly
- Prompt should be '<firstname>-PS>'
  
```ps
function prompt {'firstname-PS'}
```
## PART A : Variables
Create a variable named process and store the running processes in it.
```ps
Get-process
$processes = Get-Process
$processes
 ```
Let's execute the following Cmdlets to find processes keeping the cpu busy. 
```ps
Get-Process | Where-Object{$_.CPU -gt 2000}
```
Now, if we use variable 
```ps
$processes | Where-Object($_.CPU -gt 2000)
```
Run the following cmdlet to sort processes in descending order by memory usage with and without variable declaration.
```ps
Get-Process | Sort-Object WorkingSet64 -descending
```
and
```ps
$processes | Sort-Object WorkingSet64 -descending
```
Next, Let's explore data types. Data Types can be classified as not strong typed and strong typed. The not strong typed means the variable is not having any predefined data type.It consider the data type based on the value assigned to it.

`$myNewVariable`

```ps
$total = 2+2
$total
```
To check the methods for the variable use `Get-Member`
```ps
$total | Get-Member
```
If we put 2+2 in single quotes, it is considered as `string` data type
```ps
$total = '2+2'
$total 
$total | Get-member
```
Try some other code snipplets, Analyze the output and briefly explain your observation
```ps
$num1 = 2
$num2 = 2
$total = $num1 +$num2
$total
```
```ps
$num1 = '2'
$num2 = '2'
$total = $num1 +$num2
$total
```
Next, try some examples for strong type.
```ps
[int]$num1 = '2.6'
[int]$num2 = '1.7'
$total = $num1 + $num 2
```
As you see in the example the variable $total is of integer data type. You can convert the data type of variable from integer to string.
```ps
$stringReturn = $total.ToString()
$total | Get-Member
```

Single Quotes and Double Quotes have different meaning in PowerShell. Single Quotes consider the text as a string whereas double quotes evaluate the expression first and then display. Try the following example.
```ps
$literal =  ' Two plus one equals: $(1+2)'
$literal
$escaped = "Two plus one equals: $(1+2)"
Write-Host '$escaped' #using single quotes
Write-Host "$escaped" #using double quotes
```
Constant Variable are reserved. Use the cmdlet `Get-Variable` to see the list of all variables.
There are certain environment variables that can be seen using the cmdlet `Get-ChildItem env:`
```ps
$env:COMPUTERNAME
$env:USERNAME
```

**Use-Case: Identifying Large Files Before a Server Storage Upgrade**

Consider a scenario where users have reported that the server is running out of disk space.Before requesting additional storage hardware, you want to determine whether a small number of unusually large files are consuming most of the available space.
 
Write a script that prompt the administrator to enter the location of shared folder or drive. It recursilvely scans all subfolders, files and filters for files larger than 100MB. It counts how many large files exist and display a summary showing the number of large files found.

```ps
$path = Read-Host -Prompt 'Please enter the file path you wish to scan for large files...'
$rawFileData = Get-ChildItem -Path $path -Recurse
$largeFiles = $rawFileData | Where-Object {$_.Length -gt 100MB}
$largeFilesCount = $largeFiles | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "You have $largeFilesCount large file(s) in $path"
```
## PART B Arrays

Arrays are a fundamental feature of PowerShell. Arrays make it possible to ingest, manipulate and output true data structures. When working with an array, you can either use the same command to perform the same function on each item within an array or access and manipulate individual item using an index.

Let's create our first array that represents bowl of fruit.
```ps
$fruit = @('Apples','Oranges','Bananas')
```
You can read the array using 
```ps
$fruit
```
which will return
`Apples`
`Oranges`
`Bananas`
Powershell will automatically index them in the way "Apple" will be indexed as 0, "Oranges" as 1, and "Bananas" as 1.

Create an empty array now.
```ps
$data = @()
```
To check how many items are in the array, use `count` function
```ps
$data.count
```
Now add data to the array
```ps
$data = @('zero', 'one' , 'two' , 'three')
$data
```
We can use the index of the items in the array. Indexes start at 0, so to retreive the first item in our array use
```ps
$data[0]
```
This will return `zero`because that was the first string we put in our array.
To return multiple items use
```ps
$data[0,1,2,3]
```
This will return `zero``one``two``three`. Items are returned in the same order that you entered the indexes.
To return the sets of item from an array use
```ps
$data[1..3]
```
It will return all items with an index between 1 and 3 (inclusive)
To return the last item in the array use
```ps
$data[-1]
```
The negative number tells PowerShell to count backword from the end of the array.

To update the items in an array use
```ps
$data[2] = 'second'
```
This will update the item whose index is 2.

## Flow Control and Iteration Action on arrays
We can use a pipeline which is the character `|` When you pass an array to a pipeline each item in an array is processed individually. For instance to add a description to each item in our array, we can use this command.
```ps
$data | ForEach-Object {"Item: {$PSItem}"}
```
This command tells PowerShell to take the item in our array `$data` one at a time and then for each of them add " Item:" to the beginning, followed by the original value.
*Creating an Arrays of Objects*
We can create an array of objects in the same eay that we did  with strings, using the @() function. For instance, to make a test list of employees, we can use 
```ps
$data = @(
    [pscustomobject]@{FirstName='Kevin'; LastName='Marquette'}
    [pscustomobject]@{FirstName='John'; Lastname='Doe'}
)
To access the objects from arrays
```ps
$data[0]
or
$data[0].FirstName
```
To update the object properties use
```ps
$data[0].FirstName = 'Jay'
```
To access all the properties in an array of object use
```ps
$data | ForEach-Object {$_.LastName}
or
$data.LastName
```
This will return a list of all of the Lastname proprety in our array.

## Operators for Arrays
*-join*
It is used iteratevily on the items in an array to join them together in the output of an array
```ps
$data = @(1,2,3,4)
```
And then use -join to insert a hyphen in between each item and output the result
```ps
$data -join '-'
```
This will return `1-2-3-4` 

*-contains*
It can be use to check of an array contains a particular string and ot will output a Boolean Value. For instance
```ps
$data = @ ('red','green','blue')
$data -contains 'green'
```
This will return `true`

*equalities*
There are two operators for checking for equality in PowerShell: `-eq` and `-ne`. If you are used to using these on single values, though, the way that these work in relation to arrays can seem a little strange. If you use `-eq`, for instance, the operator will not output a Boolean `True`, but instead will return the object that matches.
```ps
$data =@('red','green','blue')
$data -eq 'green'
```
This will return `green`

The `-ne` operator works in much the same way, except that it will give you all the values that are not equal to your specified value. 
```ps
$data =@('red','green','blue')
$data -ne 'green'
```
This will return `red``blue`

## Array Addition
PowerShell can add two arrays together using the operator `+`  
```ps
$first = @('zero', 'one')
$second = @('two', 'three')
$first + $second
```
This will make a new array with all four values and output the result. It will not give this new array a new name.
Alternative to above apporoach is 
```ps
$first += 'Two, Three'
```
## Types of Arrays
*strongly typed arrays*
There are times when you want to restrict the types of data or objects that are array can hold to just one. We can do this by using a strongly typed array, which can only contain the specified data type
For instance, to make an array that can only take integers we can use
```ps
[int[]] $numbers = 1,2,3
```
If you try and put the wrong type of data value into a strongly typed array, it will return an error code.

*Array Lists*
To create an ArrayList, and then add items to it, run the following:
```ps
$myarray = [System.Collections.ArrayList]::new()
[void]$myArray.Add('Value')
```
Here, we can use the default .Net constructor to create a new ArrayList, and then using the -Add operator to add items to it. The `void` operator is there because sometimes these commands throw out strange outputs that can mess with the code.

## Additional Array Functions
*Pre-Sized Arrays*
You can create an array of a specified size by using the new($size) constructor.
```ps
$data = [Object[]]::new(4)
```
If you run a .count query on this array, it will return “4”, because even though it doesn’t have data in it, it will fill the space with 0.

*Multiplying Arrays*
Multiply the objects in an array,use
```ps
$data = @('red','green','blue')
$data * 3
```
This will create a new array with each array with each value repeated three times.

*Nested Arrays*
PowerShell supports nested arrays. To create a multi-dimensional array use
```ps
$data = @(@(1,2,3),@(4,5,6),@(7,8,9))
```
To access the value 3, we would use
```ps
$outsideIndex = 0
$insudeIndex = 2
$data[$outsideIndex][$insideIndex]
```
This will result in 3

**Use-Case: Investigating a Failed Server Backup**

A system administrator has collected a list of servers that reported backup failures overnight. Some servers appear multiple times because they failed during multiple backup jobs.
```text
$failedServers = @(
    "SRV-FILE01",
    "SRV-DB01",
    "SRV-WEB01",
    "SRV-FILE01",
    "SRV-APP01",
    "SRV-DB01",
    "SRV-BACKUP01"
)
```
Create a script that displays the total number of failure records. It also, create a list of unique servers that failed. Check whether `SRV-DB01` is in the failure list.Finally, create a semicolon-separated list of the unique failed servers. 

```ps
$failedServers = @(
    "SRV-FILE01",
    "SRV-DB01",
    "SRV-WEB01",
    "SRV-FILE01",
    "SRV-APP01",
    "SRV-DB01",
    "SRV-BACKUP01"
)
Write-Host "`nTotal Failure Records: $($failedServers.Count)"
$uniqueServers = $failedServers |
    Select-Object -Unique 
if ($uniqueServers -contains "SRV-DB01") {
    Write-Host "SRV-DB01 is in the failure list."
}
$serverList = $uniqueServers -join "; "
```

