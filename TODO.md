To Do List
==========

- [ ] Re-work `pre-commit` hook to stage updated files when it runs (currently committing does not actually commit dynamically generated files like model images and README.md).
- [ ] Add a check for existing changelog entry when attempting to commit to a release branch in a pre-commit Git hook
- [ ] Implement automatic build and release pipeline with GitHub Actions (trigger the workflow when pushed to `releases/*` branch.
