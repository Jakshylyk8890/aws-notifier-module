def extract_product_id(project_name):
    """
    Extract the product id from a project name.

    Arguments:
        project_name (str): The name of the project.

    Returns:
        str: The extracted product id.

    Raises:
        AttributeError: If the `project_name` argument is None or an empty string.
        ValueError: If the product id cannot be extracted from the `project_name`.
    """
    if project_name is None:
        raise AttributeError('Project name cannot be empty or None')
    try:
        start_index = project_name.index("PID-") + 4
        end_index = project_name.find("-", start_index)
        return project_name[start_index:end_index]

    except ValueError:
        raise ValueError('The product id was not found')
