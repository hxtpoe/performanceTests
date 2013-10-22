Introduction to jMeter
================
Before you begin to testing your app the most important thing is to take care about your organization. If you take care about clarity, the test will be low-maintenance. 
You should always use clear name convencion, then analyzing results will be easier. 
If you named all your samples "sample", analyzing results will be imposible.  
 
Here you've got an example explains you application "url extraction" and "application root file extraction" to separate config node. You can use ${APP_URL} in each place where you want. Don't forget about define "HTTP Request Defaults" in your test/scenario. This is the best place to define your base parameters like web server adres. Imagine one day you have to change server name in your huge test...  

So don't waste your time and remember to extract values to variables and define default parameters.

![alt tag](https://raw.github.com/hxtpoe/performanceTests/master/scenarios/00-introduction/addingConfigElements.png)

As you can see the simple test contains simple tree of elements. This is:
- TEST PLAN node - contains scenarios
- CONFIG ELEMENTS 
- THREAD GROUP represents application's users (it means users online - not competitive)

You can also add a "result tree" compenent. It's very useful. It makes debuging simple.
You can check request and response in easy way. 
