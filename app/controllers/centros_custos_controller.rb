class CentrosCustosController < ApplicationController
	before_filter :authenticate_admin!
end
