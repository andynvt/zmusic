import os

_out_put = "lib/resource/asset.dart"
_in_put_images = "assets/images"

def clear():
    if os.path.exists(_out_put):
        os.remove(_out_put)

def render():
    files = [f for f in os.listdir(_in_put_images)
                 if os.path.isfile(os.path.join(_in_put_images, f))
             and ('.png' in f or '.jpg' in f or '.jpeg' in f)]
    files.sort()
    with open(_out_put, 'a') as f:
        f.write('''\nclass Id {\n  Id._();\n''')
        for file in files:
            name, ext = os.path.splitext(file)
            name = name.lower()
            name = name.replace(".", "_")
            f.write("  static const String "+name+" = \""+_in_put_images+"/"+file+"\";\n")
        f.write("}\n")

def main():

    clear()
    render()

if __name__ == '__main__':
    main()