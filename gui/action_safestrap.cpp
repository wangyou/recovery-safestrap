// action_safestrap.cpp - GUIAction extension

int GUIAction::doSafestrapAction(Action action, int isThreaded /* = 0 */) {
	int simulate;
	std::string arg = gui_parse_text(action.mArg);
	std::string function = gui_parse_text(action.mFunction);
	DataManager::GetValue(TW_SIMULATE_ACTIONS, simulate);

	LOGD("doSafestrapAction(%s(%s, %d));\n", function.c_str(), arg.c_str(), isThreaded);

	if (function == "changeslot") {
		char cmd[512];
		ensure_path_unmounted("/system");
		ensure_path_unmounted("/data");
		sprintf(cmd, "/sbin/changeslot.sh %s", arg.c_str());
		__system(cmd);
		update_system_details();
		return 0;
	}

	if (function == "readbootslot") {
		char array[512];
		long lSize;
		size_t result;
		string str = "stock";

		// Read in the file, if possible
		FILE* in = fopen("/ss/safestrap/active_slot", "rb");
		if (!in) return 0;

		// obtain file size:
		fseek(in, 0, SEEK_END);
		lSize = ftell(in);
		LOGD("lSize=%d\n", lSize);
		if (lSize > 0) {
			fseek(in, 0, SEEK_SET);
			// adjust for EOF
			lSize -= 1;
			result = fread(array, 1, lSize, in);
			LOGD("result=%d\n",(long)result);
			if ((long)result == lSize)
				str = array;
		}
		fclose(in);
		ui_print("bootslot set: %s\n", str.c_str());
		DataManager::SetValue(arg, str);
		return 0;
	}

	return -1;
}

int GUIAction::doSafestrapThreadedAction(Action action, int isThreaded /* = 0 */) {
	int simulate;
	std::string pageName = gui_parse_text(action.mArg);
	std::string function = gui_parse_text(action.mFunction);
	std::string arg = "stock";
	DataManager::GetValue(TW_SIMULATE_ACTIONS, simulate);
	DataManager::GetValue("tw_trybootslot", arg);

	if (function == "createslot") {
		operation_start("createslot");
		if (arg == "stock")
			return 0;

		if (simulate) {
			simulate_progress_bar();
			ui_print("Simulating actions...\n");
		}
		else {
			int system_size = 500;
			int data_size = 1024;
			char cmd[512];

			gui_changePage(pageName);

			DataManager::GetValue("tw_slot_systen_size", system_size);
			DataManager::GetValue("tw_slot_data_size", data_size);

			DataManager::SetValue("ui_progress", 0);

			DataManager::SetValue("tw_operation", "Clearing any old files...");
			ui_print("Clearing any old files...\n");
			ensure_path_unmounted("/system");
			ensure_path_unmounted("/data");
			sprintf(cmd, "rm -rf /ss/safestrap/%s", arg.c_str());
			__system(cmd);
			__system("rm /dev/block/system");
			__system("rm /dev/block/userdata");
			__system("/sbin/bbx losetup -d /dev/block/loop7");
			__system("/sbin/bbx losetup -d /dev/block/loop6");
			DataManager::SetValue("ui_progress", 5);

			sprintf(cmd, "mkdir /ss/safestrap/%s", arg.c_str());
			__system(cmd);

			DataManager::SetValue("tw_operation", "Creating system.img...");
			ui_print("Creating system.img...\n");
			// write out 1mb blocksize # of mb times
			sprintf(cmd, "dd if=/dev/zero of=/ss/safestrap/%s/system.img bs=1M count=%d", arg.c_str(), system_size);
			__system(cmd);
			DataManager::SetValue("ui_progress", 30);

			DataManager::SetValue("tw_operation", "Writing ext3 filesystem on system...");
			ui_print("Writing ext3 filesystem on system...\n");
			sprintf(cmd, "/sbin/bbx losetup /dev/block/loop7 /ss/safestrap/%s/system.img", arg.c_str());
			__system(cmd);
			usleep(100000);
			__system("ln -s /dev/block/loop7 /dev/block/system");
			__system("mkfs.ext2 /dev/block/system");
			usleep(100000);
			__system("tune2fs -j /dev/block/system");
			DataManager::SetValue("ui_progress", 40);

			DataManager::SetValue("tw_operation", "Creating userdata.img (can take a few minutes)...");
			ui_print("Creating userdata.img (can take a few minutes)...\n");
			// write out 1mb blocksize # of mb times
			sprintf(cmd, "dd if=/dev/zero of=/ss/safestrap/%s/userdata.img bs=1M count=%d", arg.c_str(), data_size);
			__system(cmd);
			DataManager::SetValue("ui_progress", 80);

			DataManager::SetValue("tw_operation", "Writing ext3 filesystem on data...");
			ui_print("Writing ext3 filesystem on data...\n");
			sprintf(cmd, "/sbin/bbx losetup /dev/block/loop6 /ss/safestrap/%s/userdata.img", arg.c_str());
			__system(cmd);
			usleep(100000);
			__system("ln -s /dev/block/loop6 /dev/block/userdata");
			__system("mkfs.ext2 /dev/block/userdata");
			usleep(100000);
			__system("tune2fs -j /dev/block/userdata");
			DataManager::SetValue("ui_progress", 90);

			DataManager::SetValue("tw_operation", "Activating ROM slot...");
			ui_print("Activating ROM slot...\n");
			sprintf(cmd, "echo \"%s\" > /ss/safestrap/active_slot", arg.c_str());
			__system(cmd);
			DataManager::SetValue("ui_progress", 95);

			DataManager::SetValue("tw_operation", "Updating filesystem details...");
			ui_print("Updating filesystem details...\n");
			update_system_details();
			DataManager::SetValue("ui_progress", 100);
			DataManager::SetValue("tw_bootslot", arg);

			// Done
			DataManager::SetValue("ui_progress", 0);
		}
		operation_end(0, simulate);
		return 0;
	}

	return -1;
}
