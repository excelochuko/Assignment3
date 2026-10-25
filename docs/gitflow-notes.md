
# Git Branching and Gitflow

## Purpose

Git branching allows developers to work on features, releases, and fixes independently without immediately changing the main branch.

## Main Branches

- `main`: Contains stable, production-ready code.
- `develop`: Integrates completed features before a release.

## Supporting Branches

- `feature/*`: Used to develop new features. Branch from `develop` and merge back into `develop`.
- `release/*`: Used to prepare and test a release before merging into `main` and `develop`.
- `hotfix/*`: Used to fix urgent production issues. Branch from `main` and merge the fix into both `main` and `develop`.

## Typical Gitflow Process

1. Create a feature branch from `develop`.
2. Implement and test the feature.
3. Commit the changes and push the branch to GitHub.
4. Open a pull request and review the changes.
5. Merge the feature into `develop`.
6. Prepare a release branch when the project is ready.
7. Merge the release into `main` and `develop`, then tag the release.
8. For urgent production fixes, use a hotfix branch.

## Useful Git Commands

```bash
git branch
git switch -c feature/example
git add .
git commit -m "Add example feature"
git push -u origin feature/example
git switch develop
git merge feature/example
```

Gitflow is a branching strategy. GitHub Actions complements it by automatically running checks when code is pushed or a pull request is opened.
