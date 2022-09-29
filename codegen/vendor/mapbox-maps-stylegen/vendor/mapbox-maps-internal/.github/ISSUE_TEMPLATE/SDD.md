---
name: Software Design Document
about: Use this template to draft a SDD
title: "[SDD] Short title of software design document"
labels: SDD
---

# Software Design Documents (SDD)

_A software design description (a.k.a. software design document or SDD; just design document; also Software Design Specification)
is a written description of a software product, that a software designer writes in order to give a software development team
overall guidance to the architecture of the software project. An SDD usually accompanies an architecture diagram with pointers
to detailed feature specifications of smaller pieces of the design. Practically, the description is required to coordinate a large
team under a single vision, needs to be a stable reference, and outline all parts of the software and how they will work._ - Wikipedia

SDDs are the standard technical design document for the Maps SDK Teams. To start, create a new branch and commit the document to `sdd/`. Feel free to use Google Docs for early drafts and gather feedback. The end document should be preserved in this repo, as a way to monitor changes after the formal approval process.

1. This document contains a template to use when writing a Solution Design Document (SDD).
1. Retain each level-1 heading as is in the SDD.
1. Follow the instructions under each heading (and delete them).
1. Write full English sentences, as opposed to just bulleted fragments.

## Title and people

Authors: Lorem Ipsum - @github_handle
Reviewers: @mapbox/team-foobar
Revision history table:

| Date | Revision | Author | Change |
| :--- | :---: | :---: | :--- |
| 2020-01-01 | 1 | @github_handle | Created |

## Review history

| Required reviewers | Reviewed at | Review outcome |
| :--- | :---: | :--- |
| Foo |   |   |
| Bar |   |   |

## Overview

A high level summary that even non-technical readers should understand and which they can use to decide if it’s useful for them. This section should be limited to maximum 3 paragraphs.

## Context

A introduction to the problem at hand, why this project is necessary, what people need to know to assess this project, and how it fits into the technical strategy, product strategy, or the team’s quarterly goals.

## Goals and Non-Goals

The goals section should describe the impact of your project - quantify the project goals if possible.
Non-goals are as important as goals, they describe the problems you won't be fixing or which are out of scope. They set a clear boundary for what success means.

## Milestones

A list of points in time with measurable success. It's the first pass at dividing the work in digestible chunks and will help measure project success.

```
Start Date: January 2, 2020
Milestone 1 — Develop feature Foo: January 15, 2020
Milestone 2 - Perform end-to-end test on Foo in staging: January 22th, 2020
End Date: Release in production: January 30th, 2020
```

## Existing Solution

Describe the current solution if applicable or provide more context on the problem setting.
It's useful to include a high level flow of the current solution for readers to make a visual representation of the system.
Try to include all the different types of use-cases that the current system supports.

## Proposed Solution

Describe the technical architecture of the system. Again, try to do this from a high level flow of the solution.
Start of with big picture design and fill in the details after. Try to make this section detailed as possible so another engineer
could run with the implementation without asking any questions.

## Alternative Solutions

While building out the document you will face many choices. This section allows you to describe and share them with the reader.
Include why you haven't chosen for that approach by including the pros and cons of the alternative approach.

## Testing, Monitoring and Alerting

This section includes how the system will be tested, monitored and if applicable how stakeholders will be alerted.
It's important to think about these topics as they are often forgotten while working on the actual implementation.

## Cross-Team Impact

How will the project impact other teams within the organization?
What problem does it solve for other teams?
How will costs be saved with this project?
Are there any negative consequences and how will they impact other teams?
How will this project be communicated to share holders and/or customers?

## Open Questions

Include a list of open questions that the document hasn't covered.
Any open issues that you don't have a solution for.
Any decisions you want you readers to provide a voice in.

# Frequently Asked Questions (FAQ)

Identify common questions that stakeholders might formulate and their respective answers.
If the list is long, consider to update previous sections with missing information.

## Detailed Scoping and Timeline

This section is only applicable for the actual execution of the project but it's essential to to breakdown how and when you plan to execute each part of the project.
After this section is filled in, you can start writing up tickets and start planning in the work to be executed.
