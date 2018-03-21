<View style={styles.V}>
    <Text style={styles.view_run_last_updated_text}/>
    <android.support.v4.widget.SwipeRefreshLayout style={styles.swipeContainer}>
        <android.support.v7.widget.RecyclerView style={styles.view_run_list}/>
    </android.support.v4.widget.SwipeRefreshLayout>
    <Text style={styles.view_run_no_results_text}/>
    <Text style={styles.view_run_go_to_filter}/>
    <View style={styles.view_run_runnable_layout}>
        <Text style={styles.XZMWGUOA}/>
        <android.support.v4.widget.Space style={styles.SKVRAMWGI}/>
        <Switch style={styles.view_run_show_runnable}/>
    </View>
</View>

V: {
//     width: match_parent,
//     height: match_parent,
    backgroundColor: color.white,
    flexDirection: 'column',
},
view_run_last_updated_text: {
//     style: '@style/Text2',
//     width: match_parent,
//     height: wrap_content,
    layout_alignParentLeft: 'true',
    layout_alignParentTop: 'true',
    backgroundColor: color.background,
//     gravity: 'center_horizontal',
    padding: '12',
},
swipeContainer: {
//     width: match_parent,
//     height: match_parent,
    layout_alignParentLeft: 'true',
    layout_below: '@id/view_run_last_updated_text',
},
view_run_list: {
//     width: match_parent,
//     height: match_parent,
},
view_run_no_results_text: {
//     style: '@style/Headline1',
//     width: match_parent,
//     height: wrap_content,
    layout_alignParentLeft: 'true',
    layout_below: '@id/view_run_last_updated_text',
    padding: '16',
    text: '@string/no_results_try_changing_your_filter',
//     visibility: 'gone',
},
view_run_go_to_filter: {
//     style: '@style/Label1',
//     width: match_parent,
    height: 45,
    layout_below: '@id/view_run_no_results_text',
    layout_margin: '16',
    backgroundColor: '@drawable/black_oval_outline',
//     gravity: 'center',
    text: '@string/change_filters',
    color: color.font_black,
//     visibility: 'gone',
},
view_run_runnable_layout: {
//     width: match_parent,
//     height: wrap_content,
    layout_alignParentBottom: 'true',
    layout_alignParentLeft: 'true',
    layout_margin: '16',
    opacity: .9,
    backgroundColor: '@drawable/blue_oval',
},
XZMWGUOA: {
//     width: wrap_content,
//     height: wrap_content,
    marginBottom: 14,
    marginLeft: 20,
    marginTop: 14,
    text: '@string/show_runnable',
    color: color.white,
    fontSize: 14,
},
SKVRAMWGI: {
    width: 0,
//     height: wrap_content,
    flex: 1,
},
view_run_show_runnable: {
//     width: wrap_content,
//     height: match_parent,
//     layout_gravity: 'center_vertical',
    marginLeft: 16,
    marginRight: 16,
    showText: 'false',
    thumb: '@drawable/switch_thumb',
},
