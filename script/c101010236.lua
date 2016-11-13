--created & coded by Lyris
--エネルギ・アルケミー
function c101010236.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010236.target)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(c101010236.value)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c101010236.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,0xffff)
	e:GetLabelObject():SetLabel(at)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,at)
end
function c101010236.value(e,c)
	return e:GetLabel()
end
