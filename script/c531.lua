--Harmony Procedure
function c531.initial_effect(c)
	if not c531.global_check then
		c531.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c531.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c531.filterx(c)
	return c.harmony
end
function c531.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c531.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(531)==0 then
			tc:EnableReviveLimit()
			--other effects here
			
			--redirect
			local ge0=Effect.CreateEffect(tc)
			ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge0:SetCode(EFFECT_SEND_REPLACE)
			ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge0:SetRange(LOCATION_ONFIELD)
			ge0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge0:SetTarget(c531.reen)
			tc:RegisterEffect(ge0)
			--redirect
			local ge1=Effect.CreateEffect(tc)
			ge1:SetType(EFFECT_TYPE_SINGLE)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge1:SetCode(EFFECT_CANNOT_TO_DECK)
			ge1:SetCondition(function(e) return e:GetHandler():GetDestination()==LOCATION_GRAVE end)
			tc:RegisterEffect(ge1)
			local ge2=Effect.CreateEffect(tc)
			ge2:SetType(EFFECT_TYPE_SINGLE)
			ge2:SetCode(EFFECT_REMOVE_TYPE)
			ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			ge2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge2:SetValue(TYPE_SYNCHRO+TYPE_PENDULUM)
			tc:RegisterEffect(ge2)
			tc:RegisterFlagEffect(531,RESET_EVENT+EVENT_ADJUST,0,1)  
		end
		tc=g:GetNext()
	end
end
function c481.reen(e,tp,eg,ep,ev,re,r,r,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsOnField() and bit.band(c:GetDestination(),LOCATION_REMOVED)~=0 end
	Duel.SendtoExtraP(c,c:GetOwner(),r)
	return true
end
