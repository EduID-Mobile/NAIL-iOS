# NAIL-iOS
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![Swift](https://img.shields.io/badge/Language-Swift-red.svg)

NAIL API is the main idea of the data exchange for OS specific and on this project is iOS specific.
Mobile app that would like to use EduID service to authenticate and authorize specific user from EduID, required to use this API to make the whole process data exchange possible. This will ease the developer to use the service from EduID App, developer is only needed to call the API. Basic Usage would be explained below.

*Bare in mind that NAIL-iOS (NAIL API) does NOT ensure persistency, developers need to implement it themselves

## Installing

To install this library [carthage](https://github.com/Carthage/Carthage) would be required : 
If help is needed, tutorial of using carthage could be find [here](https://www.raywenderlich.com/165660/carthage-tutorial-getting-started-2)

add this line to your Cartfile 
```shell
  github "EduID-Mobile/NAIL-iOS"
  ```

## Basic Usage

Before using the NAIL-API for iOS inside the source code, developer needs to import the NAIL-iOS on top of the file code

```shell
  import NAIL_iOS
  ```
  
#### AuthorizeProtocol
This is the main function of the NAIL-API which actually the function to call the ActivityView, where the users could select EduID App as a service to authorize themselves. This function requires two parameter for itself, the first one is array of strings, this will be the protocolList, that will be passed to the EduID app. 
The EduID app will use this protocol to check if the there is any service(s) that support this protocol. (Ex.["org.ietf.oauth2"] )
The second one is the completion callback to handle the result from the Authorizing process. The result itself is a serialized string.

```shell
  NAILapi.authorizeProtocols(protocolList: protocol){
    let result = $0
  }
```
This function needs to be called **FIRST** before calling any other function. 
After this function called NAIL-iOS preserves the serialized data until the user closes the app completely.

### Service Names
This function returns an array of Strings of the Service(s) that have been authorized by the EduID app.
If there is no authorized service existed for this app, this function will return an empty array.

```shell
  NAILapi.serviceNames()
```

### Get Service Url
Just like its name this function returns an endpoint URL in String format for a specific service that has been authorized by the EduID app.
The function itself takes service name(String) parameter.

```shell
  NAILapi.getServiceUrl(serviceName: service)
```

### Get Service Token
This function returns a dictionary in format [String : Any] as result. 
This dictionary usually contains api_key, token_type, access_token and expires_in as dictionary keys.
It takes service name (String) and protocol name (String) as parameter.
(Ex. Moodle Mobile app use api_key for communicate with the Moodle Server)

```shell
  NAILapi.getServiceToken(serviceName: service, protocolName: protocol)
```

The rest of the functions could be easily seen on the [Source Code](https://github.com/EduID-Mobile/NAIL-iOS/blob/master/NAIL-iOS/NAIL-API.swift)
