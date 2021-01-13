package com.liferay.damascus.cli;

import com.beust.jcommander.Parameters;
import lombok.extern.slf4j.Slf4j;

/**
 * Create command arguments
 *
 * @author Yasuyuki Takeo
 */
@Parameters(
    commandDescription = "Create service(s) according to base.json.",
    commandNames = "create"
)
@Slf4j
public class CreateArgs extends BaseArgs {

}
