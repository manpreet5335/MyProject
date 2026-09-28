# Understanding PowerShell Objects

PowerShell is an object-oriented language and shell. This is a departure from the traditional shells like cmd and Bash. These traditional shells focused on text aka strings and while still useful, are limited in their capabilities. Nearly everything in PowerShell is an object.

### Discovering Object Members with Get-Member
Objects have many different types of information associated with them.
In PowerShell, this information is sometimes called `members`. An object member is a generic term that refers to all information associated with an object.

The `Get-Member` cmdlet allows you to find available properties, methods and aliases for any object in PowerShell.

For example, let’s say you want to view members for a particular object returned via the `Get-Service` cmdlet. You can do so by piping the output of the `Get-Service` command to the `Get-Member` cmdlet as see below.
```ps
Get-Service -ServiceName 'BITS' | Get-Member
```
Every command in PowerShell that produces output can be piped to `Get-Member`.

### Object Types and Classes
Every object has a 'schema'. An object's schema is a template that contains the blueprint to create an object. That blueprint is called a type.
Every object in PowerShell has a specific type. An object type is defined by a `class`.Objects are instances of classes with a particular type.

*Properties*
The most important concept about objects you should understand is properties. Properties are attributes that describe an object. An object can have many different properties attached to it representing various attributes.
One of the easiest ways to discover what properties exists on objects is using the `Get-Member` cmdlet. You can see below that by using the `MemberType` parameter, `Get-Member` will limit the output returned to only objects. You’ll also see it displays the object type of `System.ServiceProcess.ServiceController` as well.
```ps
Get-Service | Get-Member -MemberType 'Property'
```
Also try
```ps
Get-Service -ServiceName 'BITS' | Select-Object -Property 'StartType'
```
### Aliases
Some properties have a `MemberType`of Alias. Aliases are Pseudonyms for property names. They can sometimes give properties a more intuitive name.
```ps
Get-Service | Get-Member -MemberType 'AliasProperty`
```
You can see an example of an object with `aliases` using the `Get-Service` cmdlet. The Property `Name` is aliased to `ServiceName` and `RequiredServices` is aliased to the `ServicesDependedOn` property.

When a property has an alias you can reference that property's value using the alias name rather than the actual property name.
```ps
$Scv = Get-Service -ServiceName 'BITS'
$Scv.name
$Scv.RequiredServices
```
### Methods
Methods are the actions that can be performed on an object. Like properties, you candiscover methods on an object by using the `Get-Member` cmdlet.
```ps
Get-Service | Get-Member -MemberType 'Method'
```
### OtherMemberTypes
`Properties`, `methods`, and `aliases` are not the only types of members an object can have.
- `Script`property : these are used to calculate property values
- `Note` property : these are used for static property names.
- `PropertySets` : these are like aliases that contains just what the name implies; sets of properties. For example you have created a custom property called `Specs` for your `Get-CompInfo` functions. `Specs` is actually a subset of the properties `CPU``Mem``HDD``IP`. The primary purpose of property sets is to provide a single property name to concatenate a group of properties.
  
## Working with Objects
Many PowerShell commands produce output but sometimes you don't need to see all of this output. You need to limit or manipulate that output.
```ps
Get-Service -ServiceName * # using a wildcard on ServiceName
```
This enumerates all services on the local computer using the `Get-Service` cmdlet. You can see by the output many different services (objects) are returned.

## Controlling Returned Object Properties
To limit the properties returned you'd use the `Select-Object` cmdlet.
The `Select-Object` cmdlet 'filters' various properties from being returned to the PowerShell Pipeline.  
The `Select-Object` cmdlet “filters” various properties from being returned to the PowerShell pipeline. To “filter” object properties from being returned, you can use the `Property` parameter and specify a comma-delimited set of one or more properties to return.
```ps
Get-Service -ServiceName * | Select-Object -Property 'Status', 'DisplayName'
```
## Sorting Objects
The `sort-object` cmdlet allows you to collect all of the objects returned and then output them in the order you define.
```ps
Get-Service -ServiceName * | Select-Object -Property 'Status', 'DisplayName' | Sort-Object -Property 'Status' -Descending
```
This will return all service objects sorted by their `Status` properly returned in descending order using the `Descending` switch parameter.

## Filtering Objects

Maybe you decide you don’t want to see all of the services on a machine. Instead, you need to limit the output by specific criteria. One way to filter the number of objects returned is by using the`Where-Object` cmdlet.
While the `Select-Object` cmdlet limits the output of specific properties, the `Where-Object` cmdlet limits the output of entire objects.
```ps
Get-Service * | Select-Object -Property 'Status', 'DisplayName' | Where-Object -FilterScript {$_.Status -eq 'Running' -and $_.DisplayName -like "Windows*"} | Sort-Object -Property 'DisplayName' -Descending | Format-Table -Autosize
```
## Counting and Averaging Objects Returned
The `Measure-Object` cmdlet can count how many objects it receives via the pipeline.
```ps
Get-Service * | Select-Object -Property 'Status', 'DisplayName' | Where-Object -FilterScript {$_.Status -eq 'Running' -and $_.DisplayName -like "Windows*"} | Sort-Object -Property 'DisplayName' -Descending | Measure-Object
```
This will return the `count` `Average` `Sum` `Maximum``Minimum`

Perhaps you are looking for the total objects returned Since the `Measure-Object` command returns the total objects found via a `count` property, you can reference the `Select-Object` cmdlet again, returnig the `count` property.
```ps
Get-Service * | Select-Object -Property 'Status', 'DisplayName' | Where-Object -FilterScript {$_.Status -eq 'Running' -and $_.DisplayName -like "Windows*"} | Sort-Object -Property 'DisplayName' -Descending | Measure-Object | Select-Object -Property 'Count'
```
## Taking actions on Objects with Loops
Each object is processed via the pipeline, you can take action on each object with a loop. There are different kinds of loops in PowerShell but sticking with pipeline examples, let’s look into the `ForEach-Object` cmdlet.
The `ForEach-Object` cmdlet allows you to act on each object flowing into it.

Lets consider this example. Instead of returning entire objects or even a few properties you 'd like to return the string <serviceName> is runnig for each object using the code `Write-Host -ForegroundColor 'Yellow' <serviceName>is running.
```ps
Get-Service -ServiceName * |
	Where-Object {$_.DisplayName -Like "Windows*" -and $_.Status -eq 'Running'} | 
		Foreach-Object {
			Write-Host -ForegroundColor 'Yellow' $_.DisplayName "is running"
		}
```
## Comparing Objects
Sometimes you need to look at two objects and compare property values.
Perhaps you have two systems on your network that are nearly identical. However, you are experiencing what you expect to be a configuration issue with a service on one of the two systems.
You conclude that since these systems are in different parts of your network that you will need to use remote commands to gather the information in a PowerShell session.
`Compare-Object` allows you to compare two different objects’ property values. This cmdlet reads each property in each object, looks at their values and then returns what’s different, by default and also what’s the same.
```ps
$A = 'Svr01a.contoso.com'
$B = 'Svr02b.contoso.com'

$ProcA = Invoke-Command -Computername $A -Scriptblock {Get-Process -Name *}
$ProcB = Invoke-Command -ComputerName $B -Scriptblock {Get-Process -Name *}

Compare-Object -ReferenceObject $ProcA -DifferenceObject $ProcB
```
By default, `Compare-Object` will only return differences in the objects indicated by the SideIndicator property.  The symbols or side indicators used are `>`, `<` , `&=` to show the matches of objects being compared.
You can use the switch parameter `IncludeEqual` with `Compare-Object` to return object properties that are the same. If so, you’ll see `==` as the side indicator. Similarly, you can use `ExcludeDifferent` to leave out differences.

## Working with custom objects

One way to create your own objects is by using **Hashtables**. Hashtables are sets of key/value pairs precisely what you need for creating properties for an object.

Let’s start by creating a custom PowerShell object with some key/values using a hashtable. In the below example, you are creating a hashtable. This hashtable is representing a single object and its properties. Once the hashtable `$CarHashtable` has been defined, you then `cast` use the `PsCustomObject` type accelerator.
The `pscustomobject` type accelerator is a quick way to create an instance of the `pscustomobject` class.  This behavior is called `casting`.
```ps
## Define the hashtable
$CarHashtable = @{
	Brand      = 'Ford'
	Style      = 'Truck'
	Model      = 'F-150'
	Color      = 'Red'
	Drivetrain = '4x4'
}
## Create an object
$CarObject = [PsCustomObject]$CarHashTable

or 

$CarObject = New-Object -TypeName PsObject -Properties $CarHashtable

## Inspecting object property
$CarObject.Model
$CarObject.Color
$CarObject.Style
```
## Adding or removing properties
`Add-member` cmdlets adds members and can be used to add or remove properties
```ps
 $CarObject | Add-Member -MemberType NoteProperty -Name 'Year' -Value '2010'

 $CarHashTable | Format-Table -Autosize
 ```
You can use `Remove-Member` cmdlet or Remove () method.
```ps
$CarObject.psobject.properties.remove('Drivetrain')
```
## Methods
Methods perform some kind of action. Objects store information while methods take action.
For example, you may be aware of the `Stop-Service` command. This command stops a Windows service. To do that, you can send an object from `Get-Service` directly to `Stop-Service` to make it happen.
```ps
Get-Service -ServiceName 'BITS' | Stop-Service
Get-Service -ServiceName 'BITS'
```
By invoking `methods` on the service object itself, you can stop and retrieve the updated status all using a single object. Below you can see this in action. Notice that by using the  `Stop()`  and `Start()` methods, you can manipulate the service just like the commands did.
To ensure the `Status` property value is up to date after the service status has changed, you can invoke the `Refresh()` method which acts like another `Get-Service` command call.
```ps
## Stop BITS on the local machine
$Svc = Get-Service -ServiceName 'BITS' #Object you are working with
$Svc.Stop() #Method / action you are taking
$Svc.Refresh() #Method / action you are taking
$Svc.Status #Property

#Start BITS on the local machine
$Svc = Get-Service -ServiceName 'BITS' #Object you are working with
$Svc.Start() #Method / action you are taking
$Svc.Refresh() #Method / action you are taking
$Svc.Status #Property
```

Use Case Scenario: Find Large Log Files

A company stores application log files in the C:\Logs folder and its subfolders. Recently, the server has been running low on disk space, and the system administrator wants to identify large log files that may be contributing to the problem. 
Write a PowerShell script that searches the C:\Logs directory recursively, finds all.log files larger than 5 MB, displays each file Name, Directory Name, and Size in MB, sorts the results from the largest file to the smallest, and finally displays the total number of log files that match the criteria.

```ps
 $files = Get-ChildItem -Path "C:\Logs" -Recurse -Filter "*.log" |
Where-Object {$_.Length -gt 5MB} |
Select-Object Name, DirectoryName, @{Name='SizeMB';Expression={:Round($_.Length/1MB,2)}} |
Sort-Object SizeMB -Descending

Write-Host "Total Log Files Found: $(($files | Measure-Object).Count)"
```
 