<View style={styles.V}>
    <View style={styles.cell_run_highlight}/>
    <View style={styles.GNK}>
        <Text style={styles.cell_run_title}/>
        <Text style={styles.cell_run_detail}/>
        <Text style={styles.cell_run_level}/>
        <View style={styles.SXRMCLP}/>
        <View style={styles.XZMWGUOA}/>
    </View>
    <View style={styles.SKVRAMWGI}>
        <Text style={styles.cell_run_length}/>
        <View style={styles.YCOSOVOZPPL}/>
        <Image style={styles.cell_run_favorite}/>
        <View style={styles.YVXYOKSHVWXPY}/>
    </View>
</View>

V: {
//     width: match_parent,
    height: 100,
    flexDirection: 'row',
},
cell_run_highlight: {
    width: 8,
//     height: match_parent,
},
GNK: {
    width: 0,
//     height: match_parent,
    marginLeft: 14,
    flex: 1,
    flexDirection: 'column',
},
cell_run_title: {
//     style: '@style/Headline1',
//     width: match_parent,
//     height: wrap_content,
    marginTop: 16,
},
cell_run_detail: {
//     style: '@style/Text1',
//     width: match_parent,
//     height: wrap_content,
//     ellipsizeMode: 'end',
//     numberOfLines: '1',
},
cell_run_level: {
//     style: '@style/Label1',
//     width: match_parent,
//     height: wrap_content,
    marginBottom: 16,
    marginTop: 6,
},
SXRMCLP: {
//     width: match_parent,
    height: 0,
    flex: 1,
},
XZMWGUOA: {
//     width: match_parent,
    height: .5,
    opacity: .2,
    backgroundColor: color.font_grey,
},
SKVRAMWGI: {
//     width: wrap_content,
//     height: match_parent,
    flexDirection: 'column',
},
cell_run_length: {
//     style: '@style/Headline1',
//     width: wrap_content,
//     height: wrap_content,
    marginRight: 16,
    marginTop: 16,
},
YCOSOVOZPPL: {
//     width: match_parent,
    height: 0,
    flex: 1,
},
cell_run_favorite: {
    width: 32,
    height: 32,
    marginBottom: 16,
    marginRight: 16,
    opacity: .5,
//     scaleType: 'centerInside',
//     source: '@drawable/ic_fav_no',
},
YVXYOKSHVWXPY: {
//     width: match_parent,
    height: .5,
    opacity: .2,
    backgroundColor: color.font_grey,
},
