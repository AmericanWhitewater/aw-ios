<View style={styles.V}>
    <Text style={styles.letter}/>
    <Text style={styles.title}/>
    <Image style={styles.checkbox}/>
</View>

V: {
//     width: match_parent,
    height: 56,
    flexDirection: 'row',
},
letter: {
    width: 24,
//     height: match_parent,
    marginLeft: 16,
//     gravity: 'center_vertical',
    color: color.font_blue,
    fontSize: 24,
},
title: {
    width: 0,
//     height: match_parent,
    marginLeft: 32,
    flex: 1,
//     gravity: 'center_vertical',
    color: color.font_black,
    fontSize: 16,
},
checkbox: {
    width: 20,
    height: 16,
//     layout_gravity: 'center_vertical',
    marginLeft: 4,
    marginRight: 20,
//     visibility: 'gone',
//     source: '@drawable/ic_check',
},
