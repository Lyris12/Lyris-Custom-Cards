--created & coded by Lyris
--アトリビュート・クロスボー
function c101010168.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,nil,c101010168.tg)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c101010168.ocon)
	e2:SetTarget(c101010168.targ)
	e2:SetValue(c101010168.val)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--Double Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c101010168.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceAttribute(tp,1,0xff-tc:GetAttribute())
	e:GetHandler():RegisterFlagEffect(101010168,RESET_EVENT+0x1fe0000,0,1,rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
end
function c101010168.ocon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c:GetEquipTarget()
end
function c101010168.targ(e,c)
	if e:GetHandler():GetFlagEffect(101010168)==0 then return true end
	local at=e:GetHandler():GetFlagEffectLabel(101010168)
	return not c:IsAttribute(at)
end
function c101010168.val(e,c)
	if c:IsFaceup() then
		return 1
	else
		return 0
	end
end
