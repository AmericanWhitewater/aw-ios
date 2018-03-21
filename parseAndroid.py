import xml.etree.ElementTree as ET
import re
import sys
import string
import random
random.seed(0)
from string import Template

# A script to translate Android layout files into React Native.  Steps:
#   - Parse the Android xml layout file
#   - Translates view types (ie LinearLayout -> View)
#   - Translates attribute tags to prop names
#   - Translates and formats attribute values
#   - Writes the views as React tags, and the attributes/values as a style
#   - Comments out any attributes that don't apply or that the developer should handle manually.  
#
# Run this script like `python parseAndroid.py ~/dev/AmericanWhitewaterAndroid/app/src/main/res/layout/view_runs.xml out.js`

opening_tag_style_template = Template('<$tag style={styles.$style_name}')
opening_tag_template = Template('<$tag')
closing_tag_template = Template('</$tag>\n')

# Translate from Android view type to React component type.  
VIEW_TYPE_TRANSLATION = {
    'LinearLayout': 'View',
    'RelativeLayout': 'View',
    'TextView': 'Text',
    'ImageView': 'Image'
}

# Translate from xml attribute name to React props name.  
ATTRIBUTE_NAME_TRANSLATION = {
    'orientation': 'flexDirection',
    'layout_width': 'width',
    'layout_height': 'height',
    'layout_weight': 'flex',
    'layout_marginRight': 'marginRight',
    'layout_marginLeft': 'marginLeft',
    'layout_marginTop': 'marginTop',
    'layout_marginBottom': 'marginBottom',
    'maxLines': 'numberOfLines',
    'ellipsize': 'ellipsizeMode',
    'textColor': 'color',
    'textSize': 'fontSize',
    'srcCompat': 'source',
    'alpha': 'opacity',
    'background': 'backgroundColor'
}

# React props that have integer values
INTEGER_VALUE_PROPS = [
    'flex', 
    'fontSize', 
    'height', 
    'width', 
    'marginLeft', 
    'marginRight',
    'marginTop',
    'marginBottom',
    'opacity',
]

# Props that could not be translated or require manual intervention
PROPS_TO_COMMENT_OUT = [
    'style', 
    'gravity', 
    'layout_gravity', 
    'visibility', 
    'source', 
    'scaleType',
    'ellipsizeMode',
    'numberOfLines',
]

counter = 1 # Used to generate random style names when there is no id.

def get_component_type(android_view_type):
    return VIEW_TYPE_TRANSLATION.get(android_view_type, android_view_type)

def get_react_name(android_attrib_name):
    # Remove xml namespace that's in curly brackets
    raw_name = re.sub('{.*?}', '', android_attrib_name) 
    return ATTRIBUTE_NAME_TRANSLATION.get(raw_name, raw_name)
    
def get_react_value(react_name, android_value):
    if (react_name == 'id'):
        return android_value.replace('@+id/', '')
        
    if (react_name == 'flexDirection'):
        if (android_value == 'horizontal'):
            return 'row'
        else:
            return 'column'
    
    if '@color/' in android_value:
        color = 'color.' + android_value.replace('@color/', '')
        return color
        
    if react_name == 'fontSize':
        return android_value.replace('sp', '')
    
    return android_value.replace('dp', '')
    
# Uses the id or a random string 
def get_style_id(props):
    # The counter is ugly but it guarantees uniqueness
    global counter
    # Get a random string of length = counter
    randomString = ''.join(random.choices(string.ascii_uppercase, k=counter))
    counter += 1
    
    return props.get('id', randomString)
    
def should_quote_value(react_name, react_value):
    return not (react_name in (INTEGER_VALUE_PROPS) or 'color' in react_value)
    
def should_comment_out(react_name, react_value):
    if react_name in (PROPS_TO_COMMENT_OUT):
        return True

    return react_value in ('match_parent', 'wrap_content')
    
def get_style_from_attribs(android_attributes):
    newAttribs = {}
    
    # Transform the attribute name and value to react
    for name, value in android_attributes:
        newAttribName = get_react_name(name)
        if (len(newAttribName) > 0):
            newAttribs[newAttribName] = get_react_value(newAttribName, value)
    
    style_name = get_style_id(newAttribs)
    
    newAttribs.pop('id', None) # Don't save the id
    
    return { 
        style_name: newAttribs
    }

def write_out_styles(f, styles_dict):
    for style_name, props_dict in styles_dict.items():
        f.write(style_name + ': {\n')
        
        for name, value in props_dict.items():
            output = ''
            
            if (should_comment_out(name, value)):
                output = '// '
                
            if (should_quote_value(name, value)):
                f.write(output + '    ' + name + ': \'' + value + '\',\n')
            else:
                f.write(output + '    ' + name + ': ' + value + ',\n')
            
        f.write('},\n')

def write_with_indent(f, str, indent):
    indentationStr = ' ' * indent
    f.write(indentationStr + str)
    
# Recursively parse through each element, writes out the component tags, and returns the style dict
# Depth is used for indentation
def parse_xml_element(element, f, depth):
    # Get style props
    style_dict = get_style_from_attribs(element.items())
    style_name = next(iter(style_dict.keys()))
    
    # Add opening tag
    tag = get_component_type(element.tag)
    has_children = len(element) > 0
    
    if len(element.attrib) > 0:
        opening_tag = opening_tag_style_template.substitute(tag=tag, style_name=style_name)
        
        write_with_indent(f, opening_tag, depth * 4)
    else:
        write_with_indent(f, opening_tag_template.substitute(tag=tag), depth * 4)
        
    if has_children:
        f.write('>\n')
        
        # Call this function recursively on each child
        for child in element:
            style_dict.update(parse_xml_element(child, f, depth + 1))
            
        # Add closing tag
        write_with_indent(f, closing_tag_template.substitute(tag=tag), depth * 4)
        
    else:
        f.write('/>\n')
        
    return style_dict
    
def main():
    # Parse xml
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()

    out_file = sys.argv[2]
    
    with open(out_file, 'w') as f:
        styles = parse_xml_element(root, f, 0)
        f.write('\n')
        write_out_styles(f, styles)
    
main()    
