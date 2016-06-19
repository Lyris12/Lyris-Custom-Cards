--クリアー・プロテクター
function c101010063.initial_effect(c)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c101010063.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--barrier
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetTarget(c101010063.attg)
	e0:SetOperation(c101010063.atop)
	e0:SetLabel(0)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=e0:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTarget(c101010063.tg)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function c101010063.ratg(e)
	return e:GetHandler()
end
function c101010063.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(at)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,at)
end
function c101010063.atop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetLabelObject():SetLabel(e:GetLabel())
end
function c101010063.tg(e,c)
	return c:IsAttribute(e:GetLabel())
end
