/* toggles 'hide' on 'name', 'name-b1' and 'name-b2' (for button 1 and 2) */
function toggle3(name) {
    toggleElementClass('hide', name, name + '-b1', name + '-b2');
    return false;
}
