# Fehler früh finden: Von Unit-Tests zu BDD

<img src="./assets/pickle-gopher.png" alt="Pickle Gopher" height="200px">

A German-language presentation about software testing — starting from _why_ we test and _which options_ we have (with a strong focus on catching failures early), then going into detail on Behavior-Driven Development (BDD) and Gherkin. Examples are shown in both **Java** (JUnit, Cucumber-JVM) and **Go** (`testing`, Godog).

**Author:** Christian Budde ([@MeKo-Christian](https://github.com/MeKo-Christian))

## Origin

This is a fundamental rewrite of the talk _"Wenn Gurken-Code plötzlich Spaß macht!"_, originally presented by Christian Budde & Lukas Nagel ([@lukasngl](https://github.com/lukasngl)) at **Hannover Gophers** on October 14, 2025. The original (Go-only meetup) slides live at [lukasngl/2025-10-14-gopher-meetup-cucumber-presentation](https://github.com/lukasngl/2025-10-14-gopher-meetup-cucumber-presentation).

## Download the Slides

<a href="https://github.com/MeKo-Christian/gherkin-presentation/releases/download/latest/handout.pdf"><img src="./assets/DownTheSlide.png" alt="Download Slides" height="200px"></a>

[Download the slides (PDF)](https://github.com/MeKo-Christian/gherkin-presentation/releases/download/latest/handout.pdf)

## Overview

The talk builds up from testing fundamentals to BDD as a way of turning specifications into living documentation that serves as tests _and_ as communication for everyone involved. The running example is MeKo's medical-device measurement domain (Messvorlage, Toleranz, Maßhaltigkeit).

## Key Topics

### 1. Why test at all?

- Specifications scattered across Jira, Confluence, and chat tools
- Complex code without clear documentation; specs and code drifting apart
- Software errors in medical devices can endanger lives; regulatory requirements (MDR, FDA) mandate validation
- **Catch failures early**: the later a bug is found, the more expensive it gets

### 2. Which options do we have?

- Manual vs. automated testing — what automated tests buy us (regression safety, fast feedback)
- **The Test Pyramid**: unit / integration / end-to-end, and what each level catches
- A first concrete **unit test side by side in Java (JUnit) and Go (`testing`)** on a small tolerance check

### 3. From tests to a common language (BDD)

Code-only tests are read only by developers, and specs/code/docs drift apart. BDD follows a simple, recipe-like pattern:

```gherkin
Angenommen (Given) - Initial state
Wenn (When) - Action taken
Dann (Then) - Expected result
```

This creates a single source of truth — **Specification = Tests = Documentation**:

- **For Developers:** Clear, stable specification
- **For QA:** Automated, verifiable validation
- **For Stakeholders:** Human-readable requirements

Example:

```feature
Szenario: Stent-Dimension validieren
  Angenommen eine Messvorlage "MV-42"
    mit Toleranz 100mm ± 5mm
  Wenn ich 103mm messe
  Dann ist das Produkt in Ordnung
```

### 4. Hands-On: from behavior to specification

1. **Stakeholder Requirements** → user stories and acceptance criteria
2. **Gherkin Specification** → feature files in plain language
3. **Implementation** → step definitions connecting Gherkin to code

### 5. From test code to steps

The same classic Given/When/Then test, first in **Java/JUnit** (the students' home turf), then the **Go** equivalent — and how steps are extracted into reusable functions.

### 6. BDD frameworks: Cucumber (Java) vs. Godog (Go)

A direct comparison of the two frameworks:

| Aspect          | Cucumber-JVM (Java)                                         | Godog (Go)                                   |
| --------------- | ----------------------------------------------------------- | -------------------------------------------- |
| Step binding    | Annotation `@Angenommen/@Wenn/@Dann` **on the method**      | Registration `sc.Given/When/Then(regex, fn)` |
| Step parameters | Cucumber Expressions `{int}`/`{string}`/`{double}` or regex | Regex capture groups                         |
| Shared state    | DI (PicoContainer): constructor injection                   | `context.Context` passed through             |
| Tables          | `io.cucumber.datatable.DataTable`                           | `*godog.Table`                               |
| Multi-line text | `io.cucumber.docstring.DocString`                           | `*godog.DocString`                           |
| Runner          | JUnit 5 `@Suite` + `@IncludeEngines("cucumber")`            | `godog.TestSuite{}.Run()`                    |
| German (de)     | `io.cucumber.java.de.*` annotations                         | `# language: de` comment                     |

### 7. Gherkin highlights

- **Background**: shared setup steps for multiple scenarios
- **Scenario Outline**: parameterized tests with examples
- **Tables**: structured data input
- **DocStrings**: multi-line text input

### 8. Go tooling around Godog

- **godog**: Cucumber test framework for Go
- **ghokin**: formatter for Gherkin files
- **godotils**: table utilities for Godog
- **godogen**: colocate the step pattern with its implementation via a `//godog:step` directive — bringing Java's `@Given`-on-the-method ergonomics to Go

## Why BDD + classical testing = 💚

BDD and classical testing complement each other rather than compete:

**Before coding:** a clear, shared definition; expectations readable by everyone; early detection of misunderstandings.

**After coding:** automatic verification; easy validation; living documentation.

<img src="./assets/GopherHappy.png" alt="Gopher Happy" height="200px">

## Appendix Topics

- The history of BDD (Dan North, 2003–2004; JBehave as a JUnit successor)
- Etymology of "Cucumber" and "Gherkin"
- Challenges of BDD/Cucumber (effort to create and maintain scenarios, limited expressiveness for complex logic, scaling, stakeholder buy-in)

## Building

The slides are written in [Typst](https://typst.app/) with [Polylux](https://polylux.dev/). Common commands (see the `justfile`):

```sh
just build   # build presentation.pdf, handout.pdf, and pdfpc notes
just watch   # live preview while editing
```
