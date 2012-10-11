// action_safestrap.cpp - GUIAction extension

int createImagePartition(string slotName, string imageName, int imageSize, string mountName, int loopNum, int progressBase1, int progressBase2, int progressBase3) {
	char cmd[512];

	DataManager::SetValue("tw_operation", "Clearing old " + imageName + ".img...");

	sprintf(cmd, "/%s", mountName.c_str());
	ensure_path_unmounted(cmd);
	sprintf(cmd, "rm -rf /ss/safestrap/%s/%s.img", slotName.c_str(), imageName.c_str());
	__system(cmd);
	sprintf(cmd, "rm /dev/block/%s", imageName.c_str());
	__system(cmd);
	sprintf(cmd, "/sbin/bbx losetup -d /dev/block/loop%d", loopNum);
	__system(cmd);
	DataManager::SetValue("ui_progress", progressBase1);

	DataManager::SetValue("tw_operation", "Creating " + imageName + ".img...");
	ui_print("Creating %s.img...\n", imageName.c_str());

	sprintf(cmd, "dd if=/dev/zero of=/ss/safestrap/%s/%s.img bs=1M count=%d", slotName.c_str(), imageName.c_str(), imageSize);
	__system(cmd);
	DataManager::SetValue("ui_progress", progressBase2);

	DataManager::SetValue("tw_operation", "Writing ext3 filesystem on " + imageName + "...");
	ui_print("Writing ext3 filesystem on %s...\n", imageName.c_str());
	sprintf(cmd, "/sbin/bbx losetup /dev/block/loop%d /ss/safestrap/%s/%s.img", loopNum, slotName.c_str(), imageName.c_str());
	__system(cmd);
	usleep(100000);
	sprintf(cmd, "ln -s /dev/block/loop%d /dev/block/%s", loopNum, imageName.c_str());
	__system(cmd);
	sprintf(cmd, "mkfs.ext2 /dev/block/%s", imageName.c_str());
	__system(cmd);
	usleep(100000);
	sprintf(cmd, "tune2fs -j /dev/block/%s", imageName.c_str());
	__system(cmd);
	DataManager::SetValue("ui_progress", progressBase3);

	return 0;
}

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
		// move cache/recovery
		ensure_path_unmounted("/cache");
		sprintf(cmd, "/sbin/changeslot.sh %s", arg.c_str());
		__system(cmd);
		ensure_path_mounted("/cache");
		getLocations();
		DataManager::SetValue("tw_bootslot", arg);
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
//		ui_print("bootslot set: %s\n", str.c_str());
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

	if (function == "nandroid") {
		operation_start("Nandroid");

		if (simulate) {
			DataManager::SetValue("tw_partition", "Simulation");
			simulate_progress_bar();
		}
		else {
			if (arg == "backup") {
				nandroid_back_exe();
				DataManager::SetValue(TW_BACKUP_NAME, "(Current Date)");
			}
			else if (arg == "restore")
				nandroid_rest_exe();
			else {
				operation_end(1, simulate);
				return -1;
			}
		}
		operation_end(0, simulate);
		return 0;
	}

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
			int cache_size = 500;
			char cmd[512];

			gui_changePage(pageName);

			DataManager::GetValue("tw_slot_systen_size", system_size);
			DataManager::GetValue("tw_slot_data_size", data_size);
			DataManager::GetValue("tw_slot_cache_size", cache_size);

			DataManager::SetValue("ui_progress", 0);

			sprintf(cmd, "mkdir /ss/safestrap/%s", arg.c_str());
			__system(cmd);

			// SYSTEM
			createImagePartition(arg, "system", system_size, "system", 7, 5, 20, 30);

			// USERDATA
			createImagePartition(arg, "userdata", data_size, "data", 6, 35, 60, 70);

			// CACHE
			ensure_path_mounted("/cache");
			__system("cp -R /cache/recovery /tmp");
			__system("rm -rf /cache/recovery");
			createImagePartition(arg, "cache", cache_size, "cache", 5, 75, 85, 90);
			ensure_path_mounted("/cache");
			__system("rm -rf /cache/recovery");
			__system("cp -R /tmp/recovery /cache");
			__system("rm -rf /tmp/recovery");

			DataManager::SetValue("tw_operation", "Activating ROM slot...");
			ui_print("Activating ROM slot...\n");
			sprintf(cmd, "echo \"%s\" > /ss/safestrap/active_slot", arg.c_str());
			__system(cmd);
			DataManager::SetValue("ui_progress", 95);

			DataManager::SetValue("tw_operation", "Updating filesystem details...");
			ui_print("Updating filesystem details...\n");
			getLocations();
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
