# AGENTS.md

## Project Notes (2026-02-24)

### Hugging Face publishing
- Publish model and dataset to separate Hub repos.
- Use `hf repo create` and `hf upload` as the default workflow.
- Include `README.md` in uploads; for model repos this is the Model Card.
- Use tags for versioning and pin client/training code to a fixed `revision` (tag or commit), not `main`.

### Frontend model loading
- Start with direct model URL loading and browser HTTP cache.
- Do not add IndexedDB caching yet.
- Do not add `@huggingface/hub` in frontend for now unless auth/custom download logic is needed later.
- Avoid double-fetching the same model file.

### Version policy (current stage)
- Current line is `v0` (experimental).
- Treat label definition changes as incompatible changes.
- When labels change, bump minor line in `v0.x.0` style and tag model/dataset together.
- Keep and publish `classes.json` for each released revision and validate class-count consistency at inference time.
