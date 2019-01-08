# NumbR v 1.0.0 Technical Documentation


# Introduction

NumbR is an application created i PowerShell using the .NET framework for GUI properties. This document is for you who want to keep developing on NumbR or if you need to troubleshoot something in the app. The main purpose is to bring clarity on how the app is structured.


# Modules, quick overview

NumbR consists of 7 modules. One by one in detail;


## event_handlrs

Event handling module. 
Inside this module are functions made specifically for events when buttons are clicked. Buttons have very specific action some times, and having these nisched functions in a separate module made sense.

* add_cost
When the user adds one or many numbers to be calculated, this function is called. The function will first verify that user input does not 


