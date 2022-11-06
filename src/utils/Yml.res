let readYml = Node.Fs.readFileSync("./public/database.yml", #utf8)

let saveJson = obj => Node.Fs.writeFileSync("./dist/database.json", Js.Json.stringify(obj))

@module("js-yaml")
external _load: string => Js.Json.t = "load"

let default = readYml->_load->saveJson(#utf8)
