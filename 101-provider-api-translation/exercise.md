# Provider as API Translation Layer Exercise

**Domain:** IaC Concepts
**Topic:** A provider translates API interactions between Terraform and the service

## Description

Which of the following best describes a Terraform provider

## Learning Objectives

- Understand what a provider does
- How translation works
- Provider vs other concepts

## Background

A Terraform provider acts as a **translation layer** between Terraform Core and an infrastructure service's API. It converts Terraform's declarative resource definitions into the specific API calls required by the target service.

```
Terraform Core (HCL config)
      │
      │  "I want an aws_instance named web with
      │   ami=ami-abc123, instance_type=t3.micro"
      ▼
┌─────────────────────────────────────────────┐
│           Provider Plugin (AWS)              │
│                                              │
│  Translates HCL resource definition into     │
│  AWS EC2 API calls:                          │
│  ─────────────────────────────────           │
│  POST /EC2?Action=RunInstances               │
│  &ImageId=ami-abc123                         │
│  &InstanceType=t3.micro                      │
│  &MaxCount=1                                 │
│                                              │
│  Then translates the API response back       │
│  into Terraform state attributes             │
└─────────────────────────────────────────────┘
      │
      ▼
         AWS EC2 API (REST/JSON)
```

## Steps

### Part 1 — Understand what a provider does

1. **The provider's job:**

   A provider plugin has three core responsibilities:

   | Responsibility | What it does |
   |----------------|-------------|
   | **Resource mapping** | Exposes resource types (`aws_instance`, `azurerm_virtual_network`, `google_storage_bucket`) and their attributes |
   | **API translation** | Converts Terraform's CRUD operations into the service's specific API format (REST, gRPC, SDK calls) |
   | **Authentication** | Handles credentials, tokens, and API keys needed to access the service |

2. **Examine the config:**

   ```bash
   cat main.tf
   ```

   When you write `resource "random_pet" "example" { ... }`, the provider plugin:
   - **Receives** the resource type (`random_pet`) and attributes (`length`, `prefix`)
   - **Validates** them against its schema (e.g., `length` must be a number)
   - **Translates** them into API calls to the Random API
   - **Returns** the result (the generated pet name) to Terraform Core for state storage

### Part 2 — How translation works

3. **The API translation flow:**

   ```
   Terraform Core                   Provider Plugin              Service API
   ──────────────                   ───────────────              ──────────
        │                                │                           │
        │  Create resource request       │                           │
        │ ─────────────────────────────► │                           │
        │                                │  POST /api/resource       │
        │                                │ ───────────────────────►  │
        │                                │                           │
        │                                │  201 Created (ID, attrs)  │
        │                                │ ◄──────────────────────── │
        │                                │                           │
        │  Resource ID + attributes       │                           │
        │ ◄───────────────────────────── │                           │
        │                                │                           │
   ```

   Each provider implements this for every resource type it supports.

### Part 3 — Provider vs other concepts

4. **How a provider differs from:**

   | Concept | Is it a provider? | Why |
   |---------|:-----------------:|-----|
   | **Module** | ❌ | A module is a **collection of `.tf` files** that calls providers internally. It's configuration, not a plugin. |
   | **Provisioner** | ❌ | A provisioner runs scripts on resources **after** creation. It's a built-in feature, not a provider-level API translator. |
   | **Data source** | ❌ | A data source is a **read-only resource** exposed by the provider. The provider handles the API call, but the data source itself isn't the provider. |
   | **`required_providers` block** | ❌ | This is a **configuration declaration** that tells Terraform which provider plugins to download. Not a plugin itself. |

## Files

- `main.tf` — config demonstrating provider usage
- `outputs.tf` — output values
- `solution/` — reference implementation

