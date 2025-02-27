#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

class Queries::Notifications::Orders::ProjectOrder < Queries::Orders::Base
  self.model = Notification

  def self.key
    :project
  end

  def joins
    <<~SQL.squish
      JOIN #{WorkPackage.table_name} work_packages_order
      ON work_packages_order.id = #{Notification.table_name}.resource_id
      AND #{Notification.table_name}.resource_type = 'WorkPackage'
      JOIN #{Project.table_name}
      ON #{Project.table_name}.id = work_packages_order.project_id
    SQL
  end

  protected

  def order(scope)
    with_raise_on_invalid do
      order_string = "#{Project.table_name}.name"
      order_string += " DESC" if direction == :desc

      scope.order(order_string)
    end
  end
end
