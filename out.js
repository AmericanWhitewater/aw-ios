hello<View styles={styles.V}>
    <Text styles={styles.letter}/>
    <Text styles={styles.title}/>
    <Image styles={styles.checkbox}/>
</View>

V: {
    width: 'match_parent',
    height: '56dp',
    flexDirection: 'row',
},
letter: {
    width: '24dp',
    height: 'match_parent',
    marginLeft: '16dp',
//     gravity: 'center_vertical',
    color: color.font_blue,
    fontSize: '24sp',
},
title: {
    width: '0dp',
    height: 'match_parent',
    marginLeft: '32dp',
    flex: 1,
//     gravity: 'center_vertical',
    color: color.font_black,
    fontSize: '16sp',
},
checkbox: {
    width: '20dp',
    height: '16dp',
//     layout_gravity: 'center_vertical',
    marginLeft: '4dp',
    marginRight: '20dp',
    visibility: 'gone',
    srcCompat: '@drawable/ic_check',
},
