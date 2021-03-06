/*
 * @(#)MailTrackingInitializer.java
 *
 * Copyright 2009 Instituto Superior Tecnico
 * Founding Authors: Anil Kassamali
 * 
 *      https://fenix-ashes.ist.utl.pt/
 * 
 *   This file is part of the Correspondence Registry Module.
 *
 *   The Correspondence Registry Module is free software: you can
 *   redistribute it and/or modify it under the terms of the GNU Lesser General
 *   Public License as published by the Free Software Foundation, either version 
 *   3 of the License, or (at your option) any later version.
 *
 *   The Correspondence Registry Module is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public License
 *   along with the Correspondence Registry Module. If not, see <http://www.gnu.org/licenses/>.
 * 
 */
package module.mailtracking.domain;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import module.mailtracking.presentationTier.MailTrackingView;
import module.organization.presentationTier.actions.OrganizationModelAction;

/**
 * 
 * @author Anil Kassamali
 * 
 */
@WebListener
public class MailTrackingInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        OrganizationModelAction.partyViewHookManager.register(new MailTrackingView());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

}
