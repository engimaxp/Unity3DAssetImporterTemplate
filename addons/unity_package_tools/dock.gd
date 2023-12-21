@tool
extends MarginContainer

@onready var button = $VBoxContainer/Button
@onready var tscn_select_button = $VBoxContainer/HBoxContainer/TscnSelect
@onready var tscn_selected = $VBoxContainer/HBoxContainer/tscn_selected
const default_file_path = "res://asset/model/animation/animation_base.tscn"
const anime_import_dir = "res://Assets/Toon_Soldiers/ToonSoldiers_2/animation/Handgun/"
const anime_import_base_dir = "res://Assets/Toon_Soldiers/ToonSoldiers_2/animation/"

func _ready():
	tscn_selected.text = default_file_path
	button.pressed.connect(pressedbutton)
	tscn_select_button.pressed.connect(valid_file)

func valid_file():
	var fdir = tscn_selected.text
	print(fdir)

func iterate_dir(dir:String,result_dic:Dictionary)->void:
	var anime_dir = DirAccess.open(dir)
	var key = dir.replace(anime_import_base_dir,"")
	key = key.replace("/extracted","")
	key = key.replace("/","_")
	for f in anime_dir.get_files():
		if not f.ends_with("tres"):
			continue
		var x = load(dir.path_join(f))
		if x.is_class("Animation"):
			if not result_dic.has(key):
				result_dic[key] = []
			result_dic[key].append([f.replace(".animation.tres",""),x])
			print(f,(x as Animation).length)
	for d in anime_dir.get_directories():
		iterate_dir(dir.path_join(d),result_dic)

func pressedbutton():
	print("pressedbutton")
	var edited_scene_root = get_tree().get_edited_scene_root()
	if edited_scene_root == null:
		print("edited_scene_root == null")
		return
	var dic = {}
	# temp store animation
	iterate_dir(anime_import_dir,dic)
	print(dic)
	var scene_filename : String = edited_scene_root.scene_file_path
	for c in edited_scene_root.get_children():
		print(c.name)
	if edited_scene_root.has_node("AnimationPlayer"):
		var ap:AnimationPlayer = edited_scene_root.get_node("AnimationPlayer") as AnimationPlayer
		# save animation
		for k in dic.keys():
			var al = AnimationLibrary.new()
			ap.add_animation_library(k,al)
			for v in dic[k]:
				al.add_animation(v[0],v[1].duplicate(true))
		
		print(ap.get_animation_library_list())
		#var al:AnimationLibrary = ap.get_animation_library("") as AnimationLibrary
		#print(al.get_animation_list())
		#for x in al.get_animation_list():
			#if x == "RESET" or x == "_T-Pose_":
				#continue
			#al.add_animation(x+"1",al.get_animation(x).duplicate(true))
	print(scene_filename)
