import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState(scaffoldKey: GlobalKey<ScaffoldState>())) {
    on<OpenDrawerEvent>(_onOpenDrawerEvent);
  }

  void _onOpenDrawerEvent(OpenDrawerEvent event, Emitter<MenuState> emit) {
    if (!state.scaffoldKey.currentState!.isDrawerOpen) {
      state.scaffoldKey.currentState!.openDrawer();
    }
  }
}
