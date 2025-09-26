# OCaml Polymorphic Variants: A Summary

This document summarizes the key features of OCaml's polymorphic variants, which are defined by their structure rather than by a specific name.

---

## The Four Syntactic Forms

Polymorphic variants have four main forms that define a type's constraints. 

* **``[ `A | `B ]`` — The Exact Type**
    * **Meaning:** "Type has **exactly** `A` or `B`."
    * This is a closed type that can be one of the listed constructors, and no others.

* **``[> `A | `B ]`` — The "At Least" Type (Lower Bound)**
    * **Meaning:** "Type has `A`, `B`, and **maybe more**."
    * This is an open type, useful for writing flexible functions that can accept a variety of variant types, so long as they include the required constructors.

* **``[< `A | `B ]`` — The "Subset" Type (Upper Bound)**
    * **Meaning:** "Type is a **subset** of `{A, B}`."
    * This is a constraint that is satisfied by any type whose constructors are a subset of the ones listed. For `{A, B}`, the valid types are ``[ `A | `B ]``, ``[ `A ]``, ``[ `B ]``, and the special empty variant `[]`.

* **``[< `A | `B > `X `Y ]`` — The Constrained Subtype**
    * **Meaning:** "Type has **at most** `A` and `B`, but **at least** `X` and `Y`."
    * This is the most specific constraint, defining a type that must be a subset of `{A, B}` while also being a superset of `{X, Y}`.

---

## The Subtyping Hierarchy

A key clarification was the direction of subtyping. For polymorphic variants, a type with fewer constructors is a subtype of one with more. This creates a clear hierarchy.

``[ `A ]``   **<:** ``[ `A | `B ]``   **<:** ``[> `A | `B ]``

* A more **specific** type (fewer tags) can be used where a more **general** type (more tags) is expected.

---

## The Special Case: The Empty Variant `[]`

The empty variant is **type-theoretically valid, but the compiler will discharge it as uninhabitable, and thus there is no need to manage it.**

* **Safety via Impossibility:** The empty variant `[]` is safe precisely because it's **uninhabited**—you can never create a value of this type.
* **Compiler Guarantees:** Because no value of type `[]` can exist, the compiler can prove that any code path that would handle such a value is **unreachable**.
* **Practical Use:** This turns a theoretical curiosity into a powerful tool for correctness, allowing you to represent impossible states and model functions that never return (like `exit`).
