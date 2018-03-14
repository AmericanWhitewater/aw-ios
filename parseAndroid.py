import xml.etree.ElementTree as ET
import re
import sys
from string import Template

# Run this script like python3 parseAndroid.py ~/dev/AmericanWhitewaterAndroid/app/src/main/res/layout/cell_run.xml

tree = ET.parse(sys.argv[1])
root = tree.getroot()

out_file = sys.argv[2]

print(out_file)
print(root)
print(root.attrib)

styles = {}
counter = 0

opening_tag_style_template = Template('<$tag styles={style.$styles_name}')
opening_tag_template = Template('<$tag')
closing_tag_template = Template('</$tag>\n')

def get_tag(tag_name):
    if tag_name == 'LinearLayout':
        return 'View'
    if tag_name == 'TextView':
        return 'Text'
    if tag_name == 'ImageView':
        return 'Image'
    return tag_name

def get_attrib_name(attrib_name):
    # Remove xml namespace that's in curly brackets
    raw = re.sub('{.*?}', '', attrib_name) 
    # Replace or return the tag
    return {
        'layout_width': 'width',
        'layout_height': 'height',
        # 'layout_weight': ''
    }.get(raw, raw)

# Does basic parsing and formatting
def get_style_from_attribs(element, dict):
    newAttribs = {}
    for name, value in element.items():
        newAttribName = get_attrib_name(name)
        if (len(newAttribName) > 0):
            # Delete id mumbo jumbo
            newValue = value.replace('@+id/', '')
            newAttribs[newAttribName] = newValue
    
    # The counter is ugly but it guarantees uniqueness
    global counter
    style_name = newAttribs.get('id', str(counter))
    counter += 1
    dict[style_name] = newAttribs
    
    return style_name
    
def write_with_indent(f, str, indent):
    indentationStr = ' ' * indent
    f.write(indentationStr + str)
    
# Recursively through each element
def tags_out(element, f, level):
    # Add attribs to map of styles
    styles_name = get_style_from_attribs(element, styles)
    
    # Add opening tag
    tag = get_tag(element.tag)
    hasChildren = len(element) > 0
    
    if len(element.attrib) > 0:
        opening_tag = opening_tag_style_template.substitute(tag=tag, styles_name=styles_name)
        
        write_with_indent(f, opening_tag, level * 4)
    else:
        write_with_indent(f, opening_tag_template.substitute(tag=tag), level * 4)
        
    if hasChildren:
        f.write('>\n')
    else:
        f.write('/>\n')
        
    # Call this function recursively on each child
    for child in element:
        tags_out(child, f, level + 1)

    # Add closing tag
    if hasChildren:
        write_with_indent(f, closing_tag_template.substitute(tag=tag), level * 4)

def attribs_out(styles_dict):
    for style_name, attribs_dict in styles_dict.items():
        f.write(style_name + ': {\n')
        
        for name, value in attribs_dict.items():
            f.write('    ' + name + ': \'' + value + '\',\n')
            
        f.write('},\n')
    
with open(out_file, 'w') as f:
    tags_out(root, f, 0)
    f.write('\n')
    print(styles)
    attribs_out(styles)
    
    
