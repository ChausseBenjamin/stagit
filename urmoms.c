	fputs("</head>\n<body>\n<center>\n", fp);
	fprintf(fp, "<h1><img src=\"%slogo.png\" alt=\"\" width=\"32\" height=\"32\" /> %s <span class=\"desc\">%s</span></h1>\n",
	fputs("\n</center>\n<hr/>\n<pre>", fp);
	if (git_oid_tostr(buf, sizeof(buf), git_commit_parent_id(commit, 0)) && buf[0])
	if (!(error = git_commit_parent(&parent, commit, 0))) {
		if ((error = git_commit_tree(&parent_tree, parent)))
			goto err; /* TODO: handle error */
	} else {
		parent = NULL;
		parent_tree = NULL;
	}
	if ((error = git_diff_tree_to_tree(&diff, repo, parent_tree, commit_tree, NULL)))
		/* TODO: "new file mode <mode>". */
		/* TODO: add indexfrom...indexto + flags */
		fputs("<b>--- ", fp);
		if (delta->status & GIT_DELTA_ADDED)
			fputs("/dev/null", fp);
		else
			fprintf(fp, "a/<a href=\"%sfile/%s\">%s</a>",
				relpath, delta->old_file.path, delta->old_file.path);

		fputs("\n+++ ", fp);
		if (delta->status & GIT_DELTA_DELETED)
			fputs("/dev/null", fp);
		else
			fprintf(fp, "b/<a href=\"%sfile/%s\">%s</a>",
				relpath, delta->new_file.path, delta->new_file.path);
		fputs("</b>\n", fp);
		/* check binary data */
		if (delta->flags & GIT_DIFF_FLAG_BINARY) {
			fputs("Binary files differ\n", fp);
			git_patch_free(patch);
			continue;
		}

	int error, ret = 0;
/*		if (i++ > 100)
			break;*/
		if (git_commit_lookup(&commit, repo, &id)) {
			ret = 1;
			goto err;
		}
			goto errdiff; /* TODO: handle error */
		if (!(error = git_commit_parent(&parent, commit, 0))) {
			if ((error = git_commit_tree(&parent_tree, parent)))
				goto errdiff; /* TODO: handle error */
		} else {
			parent = NULL;
			parent_tree = NULL;
		}

		if ((error = git_diff_tree_to_tree(&diff, repo, parent_tree, commit_tree, NULL)))
errdiff:
err:
	return ret;
	if (git_oid_tostr(buf, sizeof(buf), git_commit_parent_id(commit, 0)) && buf[0])