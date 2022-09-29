---
name: 'Support escalation template'
about: Submit report of a customer issue with maps SDK (ios, android, native, embedded) for investigation and resolution by the engineering team.
title: "[Customer Name] Short description of issue"
labels: support
assignees: 

---

<!-- If a customer is requesting a new feature, please cut a ticket in the mapbox-maps-internal repo using the feature request template or add a +1 comment on an existing ticket with `cc: @sbma44`. -->

<!-- Please add labels for:
priority level (see below)
platform (ios, android, gl-native)
add the bug label if relevant -->

<!-- Priority Framework Reference
PO: Critical issue or security incident. Application does not operate (95% failure), for example due to SDK related crash that affects multiple customers on the latest version of the SDK.
P1: Customer-impacting issue or security incident that requires immediate attention from service owners. Widespread intermittent unexpected behavior impacting usability of the application. Impacts the latest SDK release. The bug impacts critical SDK functionality. The application crashes intermittently (in a way that can be reliably reproduced) which is impacting over 20% of a Mapbox customers’ own app users.
P2: High priority issue or security incident requiring action, but not affecting customers’ ability to use the product or breaching confidentiality of information. Application is operational but certain behavior is unexpected or not ideal. Or, business impact to the customer is moderate to high, directly impacting trust in product quality. Example: Application is intermittently not operational (e.g. crashes) for less than 20% of a customer’s app users due to an SDK bug, or other unexpected SDK functionality creates a moderate impact on end users with no workaround available. Does not necessitate an unplanned release.
P3: A moderate product quality issue that should be addressed, but is not affecting customers’ ability to use the product or breaching confidentiality of information. Application is operational but certain behavior is unexpected or not ideal. There is no workaround - must be fixed by Mapbox. Business impact to the customer is low. Example: The app works but specific interactions implemented with the SDK could be improved by fixing a small bug in the SDK.
P4: A minor product quality issue that should be addressed, but is not affecting customers’ ability to use the product or breaching confidentiality of information. Application is operational but certain behavior is unexpected or not ideal. There is a workaround, but for usability and product quality, the issue should be fixed on the Mapbox side. Business impact to the customer is very low. Example: The app works but specific interactions implemented with the SDK could be improved by fixing a small bug in the SDK. 
No Priority: If the issue does not fit the above categories, please do not apply a priority labels. 
-->

### Environment:

* **Platform:** < If this issue is specific to iOS or Android, please create a ticket in mapbox-maps-ios-internal or mapbox-maps-android-internal. If the issue affects both platforms, GL Native or you are unsure, you may use this template as a fallback - don't forget to add label after submitting >
* **SDK version(s):** < list versions here >
* **Device:** < device model >
* **Platform:** < ios, android, gl-native - don't forget to add label after submitting >
* **OS:** < operating system version(s) affected >
* **Simulator?** < yes/no >
* **Xcode/Android Studio version:** < list version here >

### Summary

**Customer Information:**

* **Enterprise ARR:** 
* **Customer reported urgency:** <!-- low  / medium / high / critical -->
* **Is this issue blocking the customer's release or launch?** <!-- Y or N -->
* **Estimated % of customer's users affected:**
* **Style used:**
* **Mapbox username:**

<!-- Make sure you have all of the above information filled out before submitting your issue. Ask the customer for any information you're unsure about, e.g. estimated % of their user base affected. -->

**Customer Impact**

<!-- please outline who this issue affects and the impact it is having on that customer --> 

- Date of next customer release: 

**Support ticket:** <!-- Link to the Zendesk or GitHub ticket -->

**Expected behavior**

**Actual behavior**

### Steps to reproduce

### Suspected cause (optional)

### Path to resolution (optional)

<!--
What would be helpful to resolve this?
• Is there specific team knowledge we need from someone?
• Is there any additional information we need to find the root cause?
-->
