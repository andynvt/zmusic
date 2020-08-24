import os, sys, shutil

__module__ = 'lib/module/'

def line_num_for_phrase_in_file(phrase, filename='module.dart'):
    with open(__module__ + filename,'r') as f:
        for (i, line) in enumerate(f):
            if line.startswith(phrase):
                return i
    return -1

def create_module(name):
    os.mkdir(__module__ + name)
    words = map(lambda word: word.lower().capitalize(), name.split('_')) 
    className = ''.join(words)
    with open(__module__ + name +  '/' +name+ '_view.dart', 'w') as f:
        f.write("import 'package:flutter/material.dart';\n")
        f.write("import 'package:provider/provider.dart';\n")
        f.write('\n')
        f.write("import '" +name+ "_model.dart';\n")
        f.write('\n')
        f.write('ChangeNotifierProvider<' + className + 'Model> create' + className + '() {\n')
        f.write('  return ChangeNotifierProvider(\n')
        f.write('    create: (_) => ' + className + 'Model(),\n')
        f.write('    child: _' + className + 'View(),\n')
        f.write('  );\n')
        f.write('}\n')
        f.write('\n')
        f.write('class _' + className + 'View extends StatefulWidget {\n')
        f.write('  @override\n')
        f.write('  _' + className + 'ViewState createState() => _' + className + 'ViewState();\n')
        f.write('}\n')
        f.write('\n')
        f.write('class _' + className + 'ViewState extends State<_' + className + 'View> {\n')
        f.write('  @override\n')
        f.write('  Widget build(BuildContext context) {\n')
        f.write('    final model = Provider.of<' + className + 'Model>(context);\n')
        f.write('    return Scaffold(\n')
        f.write('      appBar: AppBar(),\n')
        f.write('    );\n')
        f.write('  }\n')
        f.write('}\n')

    with open(__module__ + name + '/' +name+ '_model.dart', 'w') as f:
        f.write("import 'package:flutter/material.dart';\n")
        f.write('\n')
        f.write("import '" +name+ "_logic.dart';\n")
        f.write('\n')
        f.write('class ' + className + 'Model extends ChangeNotifier {\n')
        f.write('  ' + className + 'Logic _logic;\n')
        f.write('  ' + className + 'Logic get logic => _logic;\n')
        f.write('\n')
        f.write('  ' + className + 'Model() {\n')
        f.write('    _logic = ' + className + 'Logic(this);\n')
        f.write('  }\n')
        f.write('}\n')

    with open(__module__ + name + '/' +name+ '_logic.dart', 'w') as f:
        f.write("import '" +name+ "_model.dart';\n")
        f.write('\n')
        f.write('class ' + className + 'Logic {\n')
        f.write('  final ' + className + 'Model _model;\n')
        f.write('\n')
        f.write('  ' + className + 'Logic(this._model);\n')
        f.write('}\n')
    
    if os.path.exists(__module__ + 'module.dart'):
        export = "export './" + name + "/" +name+ "_view.dart';"
        if line_num_for_phrase_in_file(export) == -1:
            with open(__module__ + 'module.dart', 'a') as f:
                f.write('\n')
                f.write( export + '\n')

def verify_module(module_name, name, phrase):
    with open(__module__ + module_name + '/'+ module_name + '_' + name + '.dart', 'r') as f:
        for (_, line) in enumerate(f):
            if line.startswith(phrase):
                return True
    return False
 
def delete_module(name):
    words = map(lambda word: word.lower().capitalize(), name.split('_')) 
    className = ''.join(words)
    path = __module__ + name
    if os.path.exists(path + '/'+name+'_logic.dart'):
        if verify_module(name, 'logic', 'class ' + className + 'Logic {'):
            os.remove(path + '/'+name+'_logic.dart')
    
    if os.path.exists(path + '/'+name+'_model.dart'):
        if verify_module(name, 'model', 'class ' + className + 'Model extends ChangeNotifier {'):
            os.remove(path + '/'+name+'_model.dart')

    if os.path.exists(path + '/'+name+'_view.dart'):
        if verify_module(name, 'view', 'class _' + className + 'View extends StatefulWidget {'):
            os.remove(path + '/'+name+'_view.dart')

    if os.path.exists(__module__ + 'module.dart'):
        export = "export './" + name + "/" + name + "_view.dart';"
        index = line_num_for_phrase_in_file(export) 
        if index!= -1:
            with open(__module__ + 'module.dart', 'r') as f:
                with open(__module__ + '.module.dart', 'w') as out:
                    for (_, line) in enumerate(f):
                        if not line.startswith(export):
                            out.write(line)
            os.remove(__module__ + 'module.dart')
            os.rename(__module__ + '.module.dart', __module__ + 'module.dart')

    if os.path.isdir(path) and len(os.listdir(path)) == 0:
        os.rmdir(path)


def verify_module_exists(name):
    return not os.path.exists(__module__ + name)

_project = 'name: chat_bot\n'

def verify_project():
    if not os.path.exists('pubspec.yaml'):
        return False
    with open('pubspec.yaml', 'r') as f:
        line = f.readline()
        return line == _project

def verify():
    is_match = verify_project()
    if not is_match:
        print('[Error] This module only support for CryptoBadge Project.')
    return is_match

if __name__ == "__main__":
    # if not verify(): 
    #     exit(-1)
    args = sys.argv
    if len(args) == 1:
        print('> module name invalid!')
        exit(-1)
    name = args[1]
    if name == '-d':
        if len(args) == 2:
            print('> module name invalid!')
            exit(-1)
        name = args[2]
        delete_module(name)
        exit(0)

    if verify_module_exists(name):
        create_module(name)
    else:
        print('> module "'+name+'" exists!')
