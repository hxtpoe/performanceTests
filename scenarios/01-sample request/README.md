Simple 5 users test using jmeter HTTP sampler
================

Always be careful when you run tests. It's easy to kill a server! This is why we only use 5 threads in this test. I'm currently working on vagrant box for you, then you will be able to kill your VM, but not your whole workstation.
Secondly, never run all your threads in one second. You should specify "your ramp-up time" (red color on following screen). It'll usually kill your enviroument but it doesn't mean that your application works bad. It's sth like DDoS.
Add "result tree" (blue color on following screen) element when you work on your scenario. It'll be easier to know how your test works.

![alt tag](https://raw.github.com/hxtpoe/performanceTests/master/scenarios/01-sample%20request/images/01.00.numberOfThreads.png)

![alt tag](https://raw.github.com/hxtpoe/performanceTests/master/scenarios/01-sample%20request/01.01.responseAssertion.png)

![alt tag](https://raw.github.com/hxtpoe/performanceTests/master/scenarios/01-sample%20request/01.02.resultTree.png)



