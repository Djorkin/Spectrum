class_name Serializer
extends Node

var types = {
	"Vector2": {
		"serialize": func(v): return {"x": v.x, "y": v.y},
		"deserialize": func(d): return Vector2(d.x, d.y)
	},
	"Vector3": {
		"serialize": func(v): return {"x": v.x, "y": v.y, "z": v.z},
		"deserialize": func(d): return Vector3(d.x, d.y, d.z)
	}
}


func serialize(value) -> Variant:
	if value is Vector2:
		return {"__type": "Vector2", "__data": types.Vector2.serialize.call(value)}
	if value is Vector3:
		return {"__type": "Vector3", "__data": types.Vector3.serialize.call(value)}
	if value is Array:
		return value.map(serialize)
	if value is Dictionary:
		var result = {}
		for key in value:
			result[key] = serialize(value[key])
		return result
	return value


func deserialize(value) -> Variant:
	if value is Dictionary and value.has("__type"):
		var type = value["__type"]
		if types.has(type):
			return types[type].deserialize.call(value["__data"])
	if value is Array:
		return value.map(deserialize)
	if value is Dictionary:
		var result = {}
		for key in value:
			result[key] = deserialize(value[key])
		return result
	return value
