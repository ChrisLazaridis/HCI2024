extends Node2D

func _ready():
	# Define the relative path to the HTML file within the project
	var relative_path = "res://page/manual.html"
	
	# Convert the relative path to an absolute path
	var absolute_path = ProjectSettings.globalize_path(relative_path)
	
	# Attempt to open the HTML file with the default web browser
	var open_result = OS.shell_open(absolute_path)
	
	# Check if the operation was successful
	if not open_result:
		print("Failed to open the HTML file at: ", absolute_path)
	
