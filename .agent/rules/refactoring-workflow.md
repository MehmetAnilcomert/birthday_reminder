# Refactoring Workflow Rules

All refactoring tasks must follow this mandatory workflow to ensure consistency and quality.

## 1. User Consultation
Before any action, the AI must ask the user:
- **Requirement**: Ask the user: *"Which component or piece of code would you like to refactor, and what is the primary goal of this refactor?"*
- **Action**: Use this information to define the scope for the Issue and Implementation Plan.

## 2. Issue Creation
Based on the user's input, open a GitHub issue.
- **Title**: Must follow the pattern `Refactor: [Short Description of Change]`.
- **Description**: Must be written in **English**. It should clearly state the purpose of the refactor, the user's requirements, and the desired technical outcome.
- **Label**: The issue must be tagged with the `refactor` label.

## 3. Branching Strategy
All refactoring work must be performed in a dedicated branch.
- **Naming**: `refactor/[issue-id]-[short-desc]` (based on the created issue).
- Create and switch to this branch before any modifications.

## 4. Planning & Implementation Plan
Prepare the `implementation_plan.md` based on the previously gathered user requirements.

## 5. Execution
- Implement the changes according to the approved `implementation_plan.md`.
- Follow best practices and maintain project-specific code styles.

## 6. Commit and Pull Request
- **Commits**: Use clear, descriptive commit messages.
- **Pull Request**: Push the branch and create a Pull Request. The PR must:
    - Reference the issue (e.g., `Closes #123`).
    - Provide a summary of the changes made.
