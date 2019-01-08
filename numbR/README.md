

# NumbR. Quotations made easy


## What is numbR?

NumbR is made with user experience as No #1 priority and the sole purpose of the app is to help making quotations easier to create. NumbR is an app for making it easier calculating and building quotations for your customers.
It consists of a simple UI with few choices and a straight-forward approach.

## Functionality

NumbR can help you keep track on different mathematical rules applying for various cases. Let's say that you 
need to memorize the multiplicands for a Mac repair, for one customer only. Or, one customer signed a deal which reduces 
the shipping cost or removes it entirely. NumbR will memorize this for you and make it easy to get going with your quotations.

Let's break it down to detail level.

###	Dark mode
	
Dark mode is just what it sounds like. Dark mode! Toggle the switch if you want your NumbR looking dark and cool, 
or white and inviting.

###	Rounding

Rounding allows you to toggle mathematical rounding of the total sum on or off. This means, that if it is off, your final price will include decimals if present. On the other hand, with rounding on, NumbR will make like a human - and round up or down to the closest integer.

###	iPad Mac PC

As of right now, NumbR supports (3) different 'States'. NumbR refers to your selected repair as 'State' and the values on the chalkboard will follow when you toggle a different repair. Neat, right!? 

###	Keep track of your customers

NumbR has great memory. So good in fact, that it can remember everything that you tell it about your customers!
Every customer have their own profile of values on the chalkboard. That means if you change shipping on iPad repairs for customer X, customer Y will be left untouched. Even your latest state, dark mode setting and rounding setting is saved for the particular customer! 

###	Get a fully transparent view of your quotation

When you create a quotation, you can choose to enter each cost one by one or add them all in one line separated by ";". An example would look like 

	100,50;600;100;9999

After you've added your costs and calculate the total net sum, you can generate a quick quotation template by clicking the 'Create quotation' button. Just paste it wherever you want, and you're done! 

###	Add customers on the go

NumbR comes with a presumptuous array of default values for the chalkboard. You can change these values at your will, but a better idea is to create a new customer with their own set of rules. It's easy! Click 'New customer' and enter the name. Done! Just edit the chalkboard and click save.

###	Top Most view 
	
NumbR is a bossy little app. It will reside on top of any other application you have open. This mode is currently 
not mutable (cannot be turned on or off) - but might be if many enough request it. 
The point with this to help when having your web browser with the quotation in the making, and not having to resize windows or switching frenetically when you use NumbR. If you want, you can just minimize NumbR if you're not using it. 

## How to use

Simply download the installer and run it! Remember to get the uninstaller too if you change your mind.

NumbR V.1.0.0 has been tested on x64 versions of Windows 10: SKU 1803. Any other version is unsupported bug might work just as well.

NumbR will show on your desktop. Important notice, NumbR needs to set your execution policy to "RemoteSigned" in order to run. This is automatic, and you're prompted when this is done. 
Upon uninstalling NumbR, the execution policy is reverted to "Restricted."

## I found a bug! 

Those nasty little critters. If you found it, please be quick and take a picture of it or just write a description of it as good as you can and email it to simon.olofsson@advania.se. 
I'll make sure to investigate it further. 

## Technical jargon

NumbR is build using the .NET framework in PowerShell. Various C# methods are used to display the GUI and all items in it. By the use of PowerShell, NumbR enables quick compatibility and ease of implementation and modification with the easy and friendly syntax of PowerShell. Details on the modules that make up NumbR and how the code is structured can be found in the technical manual for NumbR, as well as source code comments.


## ToDo

* Feature / Bug fix: prohibit the possibility of entering more than one decimal notation (.) in a single price. Illogical and causes conversion error.

* Feature: Strip the clipboard version of component prices of the decimals. E.g, if a component costs 172.3 SEK, display only 172 in the clipboard quotation.

* Feature: Create functionality for exporting and importing JSON files (customer configurations) through the UI

* Tool: Build NumbR Updater
